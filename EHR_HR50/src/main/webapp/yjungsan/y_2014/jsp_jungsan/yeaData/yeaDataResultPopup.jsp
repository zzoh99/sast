<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html class="hidden"><head> <title>세금계산 결과보기</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
    var p = eval("<%=popUpStatus%>");

    $(function(){
        var arg = p.window.dialogArguments;

        if( arg != undefined ) {
            $("#searchWorkYy").val(arg["searchWorkYy"]);
            $("#searchAdjustType").val(arg["searchAdjustType"]);
            $("#searchSabun").val(arg["searchSabun"]);
            $("#searchGubun").val(arg["searchGubun"]);
            $("#searchReCalcSeq").val(arg["searchReCalcSeq"]);
            $("#searchPayActionCd").val(arg["searchPayActionCd"]);
        }else{
            var searchWorkYy      = "";
            var searchAdjustType  = "";
            var searchSabun       = "";
            var searchGubun       = "";
            var searchReCalcSeq   = "";
            var searchPayActionCd = "";
            
            searchWorkYy      = p.popDialogArgument("searchWorkYy");
            searchAdjustType  = p.popDialogArgument("searchAdjustType");
            searchSabun       = p.popDialogArgument("searchSabun");
            searchGubun       = p.popDialogArgument("searchGubun");
            searchReCalcSeq   = p.popDialogArgument("searchReCalcSeq");
            searchPayActionCd = p.popDialogArgument("searchPayActionCd");
            
            $("#searchWorkYy").val(searchWorkYy);
            $("#searchAdjustType").val(searchAdjustType);
            $("#searchSabun").val(searchSabun);
            $("#searchGubun").val(searchGubun);
            $("#searchReCalcSeq").val(searchReCalcSeq);
            $("#searchPayActionCd").val(searchPayActionCd);
        }
        
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
            {Header:"curr_notax_work_mon",      Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_notax_work_mon",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_notax_etc_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_notax_etc_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
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
            {Header:"curr_notax_baby_mon",      Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_notax_baby_mon",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_notax_forn_mon",      Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_notax_forn_mon",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_notax_research_mon",  Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_notax_research_mon", KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_notax_baby_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_notax_baby_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_notax_forn_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_notax_forn_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_notax_research_mon",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_notax_research_mon",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_notax_abroad_mon",     Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_notax_abroad_mon",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_notax_work_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_notax_work_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_notax_etc_mon",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_notax_etc_mon",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_notax_ext_mon",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_notax_ext_mon",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_stock_buy_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_stock_buy_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_stock_union_mon",     Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_stock_union_mon",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_stock_buy_mon",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_stock_buy_mon",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_stock_union_mon",      Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_stock_union_mon",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_imwon_ret_over_mon",  Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_imwon_ret_over_mon", KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_imwon_ret_over_mon",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_imwon_ret_over_mon",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"limit_over_mon",           Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"limit_over_mon",          KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
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
                {Header:"a00001",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a000_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a01001",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a010_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a01003",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a010_03",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a01011",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a010_11",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a02004",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a020_04",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a02007",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a020_07",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03001",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a04003_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_03_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a04004_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_04_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <% //2015-04-23 추가,수정 start%>
                {Header:"a04005_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_05_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a04005_std",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_05_std",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a04007_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_07_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a04007_std",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_07_std",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <% //2015-04-23 추가,수정 end%>
                {Header:"a05001_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a050_01_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a05001_std",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a050_01_std",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06001_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_01_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06001_std",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_01_std",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a05001",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a050_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06001",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07014",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_14",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07021",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_21",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07017",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_17",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07015",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_15",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07016",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_16",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07022",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_22",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07023",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_23",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
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
                {Header:"b01301",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b013_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a09901",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a099_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },                  
                {Header:"b01001",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01003",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_03",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01005",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_05",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01007",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_07",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01014",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_14",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01015",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_15",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01016",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_16",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01017",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_17",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01014_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_14_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01015_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_15_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b0103031_inp", Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_30_31_inp",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01017_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_17_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01013",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_13",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a02005",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a020_05",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06011",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_11",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b00001",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b000_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b00010",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b000_10",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },          
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
                {Header:"a08007",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_07",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08009",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_09",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08009_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_09_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },          
                {Header:"a08010",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_10",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08011",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_11",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a09901",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a099_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10003_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_03_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10030_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_30_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10040_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_40_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
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
                {Header:"a10014",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_14",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10017",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_17",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10021_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_21_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10026",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_26",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10027",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_27",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10028",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_28",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10037_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_37_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10099",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_99",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01001_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_01_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01003_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_03_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01005_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_05_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01005_std",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_05_std",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01009",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_09",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a02014",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a020_14",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03004",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_04",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03004_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_04_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03004_std",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_04_std",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03003",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_03",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03003_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_03_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03003_std",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_03_std",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10005",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_05",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10005_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_05_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10005_std",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_05_std",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a05020",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a050_20",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a05021",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a050_21",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06020",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_20",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06021",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_21",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10009",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_09",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10012",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_12",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10055",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_55",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10056",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_56",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10016",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_16",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10038",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_38",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10038_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_38_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10034_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_34_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10031_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_31_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10033_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_33_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08005",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_05",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08005_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_05_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08005_std",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_05_std",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08003",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_03",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08003_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_03_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08003_std",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_03_std",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a080013",      Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_13",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08001011_inp",Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_10_11_inp",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a080013_std",  Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_13_std",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a09902",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a099_02",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08020",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_20",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03011",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_11",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03012",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_12",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03002",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_02",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03013",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_13",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03011_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_11_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03012_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_12_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03002_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_02_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03013_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_13_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 }
            ]; IBS_InitSheet(yeaResultSht5, initdata3);yeaResultSht5.SetEditable(false);yeaResultSht5.SetVisible(true);yeaResultSht5.SetCountPosition(4);
            
        yeaResultSht3.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectRes3List", $("#yeaResultShtForm").serialize() );
        yeaResultSht2.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectRes2List871", $("#yeaResultShtForm").serialize() );
        yeaResultSht5.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectRes5List873", $("#yeaResultShtForm").serialize() );
    });

    $(function(){
        //Cancel 버튼 처리 
        $(".close").click(function(){
            p.self.close(); 
        });
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
            $("#sht2_CurrTotMon").val(          yeaResultSht2.GetCellText(1, "curr_tot_mon")) ;//현근무지소득계
            $("#sht2_PrePayMon").val(           yeaResultSht2.GetCellText(1, "pre_pay_mon")) ;//종전근무지급여 
            $("#sht2_PreBonusMon").val(         yeaResultSht2.GetCellText(1, "pre_bonus_mon"));//종전근무지상여
            $("#sht2_PreEtcBonusMon").val(      yeaResultSht2.GetCellText(1, "pre_etc_bonus_mon")) ;//종전근무지인정상여
            $("#sht2_PreStockBuyMon").val(      yeaResultSht2.GetCellText(1, "pre_stock_buy_mon")) ;//종전근무지주식매수선택권행사이익
            $("#sht2_PreStockSnionMon").val(    yeaResultSht2.GetCellText(1, "pre_stock_union_mon")) ;//종전근무지우리사주조합인출금
            $("#sht2_PreImwonRetOverMon").val( yeaResultSht2.GetCellText(1, "pre_imwon_ret_over_mon")) ;//종전근무지임원퇴직소득금액한도초과액
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
            yeaResultSht2.SetCellValue(1, "temp", yeaResultSht2.GetCellValue(1, "curr_tot_mon")+yeaResultSht2.GetCellValue(1, "pre_tot_mon") ) ;
            $("#sumTotMon").val(            yeaResultSht2.GetCellText(1, "temp"));
            $("#sumPayMon").val(        $("#sumPayMon").val()       );
            $("#sumBonusMon").val(      $("#sumBonusMon").val()     );
            $("#sumEtcBonusMon").val(   $("#sumEtcBonusMon").val()  );
            $("#sumStockBuyMon").val(   $("#sumStockBuyMon").val()  );
            $("#sumStockSnionMon").val( $("#sumStockSnionMon").val());
            $("#sumTotMon").val(        $("#sumTotMon").val()       );
            $("#sht2_CurrNotaxAbroadMon").val(      yeaResultSht2.GetCellText(1, "curr_notax_abroad_mon"));//현근무지국외근로비과세
            $("#sht2_CurrNotaxWorkMon").val(        yeaResultSht2.GetCellText(1, "curr_notax_work_mon"));//현근무지야간근로수당비과세
            $("#sht2_CurrNotaxBabyMon").val(        yeaResultSht2.GetCellText(1, "curr_notax_baby_mon"));//현근무지출산보육비과세
            $("#sht2_CurrNotaxFornMon").val(        yeaResultSht2.GetCellText(1, "curr_notax_forn_mon"));//현근무지외국인근로자비과세
            $("#sht2_CurrNotaxResMon").val(         yeaResultSht2.GetCellText(1, "curr_notax_research_mon"));//현근무지연구보조비비과세                     
            $("#sht2_CurrNotaxEtcMon").val(         yeaResultSht2.GetCellText(1, "curr_notax_etc_mon"));//현근무지기타비과세
            $("#sht2_CurrNotaxExtMon").val(         yeaResultSht2.GetCellText(1, "curr_notax_ext_mon"));//현근무지그외비과세
            $("#sht2_CurrNotaxTotMon").val(         yeaResultSht2.GetCellText(1, "curr_notax_tot_mon"));//현근무지비과세계
            $("#sht2_PreNotaxAbroadMon").val(       yeaResultSht2.GetCellText(1, "pre_notax_abroad_mon"));//종전근무지국외근로비과세
            $("#sht2_PreNotaxWorkMon").val(         yeaResultSht2.GetCellText(1, "pre_notax_work_mon"));//종전근무지야간근로수당비과세
            $("#sht2_PreNotaxBabyMon").val(         yeaResultSht2.GetCellText(1, "pre_notax_baby_mon"));//종전근무지출산보육비과세
            $("#sht2_PreNotaxFornMon").val(         yeaResultSht2.GetCellText(1, "pre_notax_forn_mon"));//종전근무지외국인근로자비과세
            $("#sht2_PreNotaxResMon").val(          yeaResultSht2.GetCellText(1, "pre_notax_research_mon"));//종전근무지연구보조비비과세
            $("#sht2_PreNotaxEtcMon").val(          yeaResultSht2.GetCellText(1, "pre_notax_etc_mon"));//종전근무지기타비과세
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
        } else{
            
            
            $("#sht2_CurrPayMon").val(           "0");//현근무지급여 
            $("#sht2_CurrBonusMon").val(         "0");//현근무지상여 
            $("#sht2_CurrEtcBonusMon").val(      "0");//현근무지인정상여
            $("#sht2_CurrStockBuyMon").val(      "");//현근무지주식매수선택권행사이익
            $("#sht2_CurrStockSnionMon").val(    "");//현근무지우리사주조합인출금
            $("#sht2_CurrImwonRetOverMon").val("");//현근무지임원퇴직소득금액한도초과액
            $("#sht2_CurrTotMon").val(           "0");//현근무지소득계
            $("#sht2_PrePayMon").val(            "0");//종전근무지급여 
            $("#sht2_PreBonusMon").val(          "0");//종전근무지상여
            $("#sht2_PreEtcBonusMon").val(       "0");//종전근무지인정상여
            $("#sht2_PreStockBuyMon").val(       "");//종전근무지주식매수선택권행사이익
            $("#sht2_PreStockSnionMon").val(     "");//종전근무지우리사주조합인출금
            $("#sht2_PreImwonRetOverMon").val("0");//종전근무지임원퇴직소득금액한도초과액
            $("#sht2_PreTotMon").val(            "0");//종전근무지소득계
            $("#sumPayMon").val(                 "0");
            $("#sumBonusMon").val(               "0");
            $("#sumEtcBonusMon").val(            "0");
            $("#sumImwonRetOverMon").val("0");
            $("#sumTotMon").val(                 "0");
            $("#sht2_PreNotaxAbroadMon").val(        "0");//종전근무지국외근로비과세
            $("#sht2_PreNotaxWorkMon").val(          "0");//종전근무지야간근로수당비과세
            $("#sht2_PreNotaxEtcMon").val(           "0");//종전근무지기타비과세
            $("#sht2_PreNotaxExtMon").val(           "0");//종전근무지그외비과세
            $("#sht2_PreNotaxResMon").val(           "0");//종전근무지연구보조비비과세
            $("#sht2_PreNotaxFornMon").val(          "0");//종전근무지외국인근로자비과세          
            $("#sht2_PreNotaxBabyMon").val(          "0");//종전근무지출산보육비과세                        
            $("#sht2_PreNotaxTotMon").val(           "0");//종전근무지비과세계
            $("#sht2_CurrNotaxAbroadMon").val(       "0");//현근무지국외근로비과세
            $("#sht2_CurrNotaxWorkMon").val(         "0");//현근무지야간근로수당비과세
            $("#sht2_CurrNotaxEtcMon").val(          "0");//현근무지기타비과세
            $("#sht2_CurrNotaxExtMon").val(          "0");//현근무지그외비과세
            $("#sht2_CurrNotaxResMon").val(          "0");//현근무지연구보조비비과세
            $("#sht2_CurrNotaxFornMon").val(         "0");//현근무지외국인근로자비과세           
            $("#sht2_CurrNotaxBabyMon").val(         "0");//현근무지출산보육비과세                     
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
            }
        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }
    
    //조회 후 에러 메시지
    function yeaResultSht5_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
            if(Code == 1) {
                sht5ToCtl();
            }
        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }
</script>
</head>
<body class="bodywrap">

<div class="wrapper" style="overflow:scroll;">
    <div class="popup_title">
        <ul>
            <li><span id="title">세금계산 결과보기</span></li>
            <!--<li class="close"></li>-->
        </ul>
    </div>
    <div class="popup_main" >
    <form id="yeaResultShtForm" name="yeaResultShtForm" >
        <input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
        <input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
        <input type="hidden" id="searchSabun" name="searchSabun" value="" />
        <input type="hidden" id="searchGubun" name="searchGubun" value="" />
        <input type="hidden" id="searchReCalcSeq" name="searchReCalcSeq" value="" />
        <input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="" />
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
        <col width="13%" />
        <col width="13%" />
        <col width="13%" />
        <col width="13%" />
        <col width="13%" />
        <col width="13%" />
        <col width="13%" />
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
        <th class="center">야간근로</th>
        <th class="center">외국인</th>
        <th class="center">연구보조비</th>
        <th class="center">지정</th>
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
            <th class="center" rowspan="11">특별공제</th>
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
            <th class="center" rowspan="7">주택자금</th>
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
            <th class="center" rowspan="5">장기주택저당차입금</th>
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
        <tr>
            <th class="center" rowspan="6">투자조합 출자공제</th>
            <th class="center" rowspan="2" >2012.1.1 ~ 2012.12.31</th>
            <th class="center" colspan="2">간접출자</th>
            <td class="right"> 
                <input id="sht5_A100_08" name="sht5_A100_08" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right" rowspan="6"> 
                <input id="sht5_A100_07" name="sht5_A100_07" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">직접출자</th>
            <td class="right"> 
                <input id="sht5_A100_10" name="sht5_A100_10" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="2" >2013.1.1 ~ 2013.12.31</th>
            <th class="center" colspan="2">간접출자</th>
            <td class="right"> 
                <input id="sht5_A100_09" name="sht5_A100_09" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">직접출자</th>
            <td class="right"> 
                <input id="sht5_A100_12" name="sht5_A100_12" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="2" >2014.1.1 ~ 2014.12.31</th>
            <th class="center" colspan="2">간접출자</th>
            <td class="right"> 
                <input id="sht5_A100_55" name="sht5_A100_55" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">직접출자</th>
            <td class="right"> 
                <input id="sht5_A100_56" name="sht5_A100_56" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="6">신용카드등 사용액 <br>소득공제</th>
            <th class="center" >신용카드 등</th>
            <th class="center" colspan="2"></th>
            <td class="right"> 
                <input id="sht5_A100_15" name="sht5_A100_15" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right" rowspan="6"> 
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
            <th class="center" colspan="2">우리사주조합 기부금</th>
            <th class="center" colspan="2"></th>
            <td class="right"> 
                <input id="sht5_A080_09_INP" name="sht5_A080_09_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right"> 
                <input id="sht5_A080_09" name="sht5_A080_09" type="text" class="text w100p right" readOnly />
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
            <th class="center" rowspan="35">세액공제</th>
            <th class="center" colspan="2">근로소득</th>
            <th class="center" colspan="2"></th>
            <th class="center" ></th>
            <td class="right"> 
                <input id="sht5_B000_01" name="sht5_B000_01" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <%//2015-04-23 수정,추가 start %>
        <tr>
            <th class="center" colspan="2" rowspan="3">자녀 세액공제</th>
            <th class="center" >자녀</th>
            <td class="center" ><input id="sht5_B000_10_CNT" name="sht5_A010_11_CNT" type="text" class="text w90p right" readOnly /> 명</td>
            <th class="center" ></th>
            <td class="right"> 
                <input id="sht5_B000_10" name="sht5_B000_10" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" >6세이하자녀양육공제</th>
            <td class="center" ><input id="sht5_B001_20_CNT" name="sht5_B001_20_CNT" type="text" class="text w90p right" readOnly /> 명</td>
            <th class="center" ></th>
            <td class="right"> 
                <input id="sht5_B001_20" name="sht5_B001_20" type="text" class="text w100p right" readOnly />
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
            <th class="center" rowspan="18">특별세액공제</th>
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
            <th class="center" rowspan="8">기부금</th>
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
    </form>
    <div class="popup_button outer">
        <ul>
            <li>
                <a href="javascript:p.self.close();" class="gray large">닫기</a>
            </li>
        </ul>
    </div>
    
    <span class="hide">
        <script type="text/javascript">createIBSheet("yeaResultSht2", "100%", "100%"); </script>
        <script type="text/javascript">createIBSheet("yeaResultSht3", "100%", "100%"); </script>
        <script type="text/javascript">createIBSheet("yeaResultSht5", "100%", "100%"); </script>
    </span>
    </div>
</div>

</body>
</html>