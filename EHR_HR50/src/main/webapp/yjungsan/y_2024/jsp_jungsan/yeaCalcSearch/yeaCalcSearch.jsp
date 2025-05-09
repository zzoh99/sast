<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>정산계산내역조회</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<% String reCalc = (request.getParameter("reCalc")==null) ? "" : (String)request.getParameter("reCalc"); %>
<script type="text/javascript">
 
    $(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
        $("#searchWorkYy").val("<%=yeaYear%>");

        var initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
                        {Header:"No|No",       Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
                        
                        {Header:"작업정보|년도",            Type:"Text",            Hidden:1,  Width:60,     Align:"Center",    ColMerge:1,   SaveName:"work_yy",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"작업정보|귀속년월",         Type:"Date",           Hidden:0,  Width:80,     Align:"Center",    ColMerge:1,   SaveName:"pay_ym",                         KeyField:0,   CalcLogic:"",   Format:"Ym",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"작업정보|지급일자",         Type:"Date",           Hidden:0,  Width:100,     Align:"Center",    ColMerge:1,   SaveName:"payment_ymd",                         KeyField:0,   CalcLogic:"",   Format:"Ymd",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"작업정보|급여명",          Type:"Text",           Hidden:0,  Width:100,     Align:"Center",    ColMerge:1,   SaveName:"pay_action_nm",                         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"작업정보|계산상태",         Type:"Combo",           Hidden:0,  Width:100,     Align:"Center",    ColMerge:1,   SaveName:"pay_people_status",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"작업정보|작업\n일자",       Type:"Text",            Hidden:0,  Width:100,    Align:"Center",    ColMerge:1,   SaveName:"chk_date",                      KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"작업정보|작업자\n사번",      Type:"Text",            Hidden:0,  Width:100,    Align:"Center",    ColMerge:1,   SaveName:"chkid",                         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },

                        {Header:"작업정보|정산구분",         Type:"Text",       Hidden:1,  Width:60,     Align:"Center",    ColMerge:1,   SaveName:"adjust_type",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"작업정보|정산구분",		    Type:"Combo",		Hidden:0,  Width:70,	Align:"Center",	 ColMerge:0,   SaveName:"adjust_type_nm", KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                        {Header:"작업정보|재계산\n구분",     Type:"Combo",		Hidden:1,  Width:70,	Align:"Center",	 ColMerge:0,   SaveName:"gubun",	      KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                        {Header:"작업정보|재계산\n차수",	    Type:"Int",		    Hidden:1,  Width:60,	Align:"Center",	 ColMerge:0,   SaveName:"re_seq",	      KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                        
                        {Header:"대상정보|사번",            Type:"Text",            Hidden:0,  Width:80,     Align:"Center",    ColMerge:1,   SaveName:"sabun",                         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"대상정보|성명",            Type:"Text",            Hidden:0,  Width:80,     Align:"Center",    ColMerge:1,   SaveName:"name",                          KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },                        
                        {Header:"대상정보|신고\n제외\n여부",  Type:"Combo",           Hidden:0,  Width:60,     Align:"Center",    ColMerge:1,   SaveName:"except_yn",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"대상정보|외국인\n단일세율",   Type:"Combo",           Hidden:0,  Width:60,     Align:"Center",    ColMerge:1,   SaveName:"foreign_tax_type",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"대상정보|부서",            Type:"Text",            Hidden:0,  Width:100,    Align:"Left",    ColMerge:1,   SaveName:"org_nm",                        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"대상정보|직위",            Type:"Text",            Hidden:0,  Width:70,    Align:"Center",    ColMerge:1,   SaveName:"jikwee_nm",                        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"대상정보|직급",            Type:"Text",            Hidden:0,  Width:70,    Align:"Center",    ColMerge:1,   SaveName:"jikgub_nm",                        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        /* {Header:"주민번호",             Type:"Text",            Hidden:0,  Width:130,    Align:"Center",    ColMerge:1,   SaveName:"res_no",                        KeyField:0,   CalcLogic:"",   Format:"IdNo",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, */
                        {Header:"대상정보|사업장",           Type:"Text",            Hidden:0,  Width:80,     Align:"Center",    ColMerge:1,   SaveName:"business_place_nm",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"대상정보|입사일",           Type:"Text",            Hidden:0,  Width:100,    Align:"Center",    ColMerge:1,   SaveName:"emp_ymd",                       KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"대상정보|퇴사일",           Type:"Text",            Hidden:0,  Width:100,    Align:"Center",    ColMerge:1,   SaveName:"ret_ymd",                       KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },                      
                        
                        {Header:"종전 과세|급여액",          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_pay_mon",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종전 과세|상여액",          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_bonus_mon",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종전 과세|인정상여",         Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_etc_bonus_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종전 과세|주식매수\n선택권\n행사이익",   Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"pre_stock_buy_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종전 과세|우리사주\n조합\n인출금",      Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"pre_stock_union_mon",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종전 과세|임원\n퇴직소득\n한도초과액",   Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"pre_imwon_ret_over_mon",        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종전 과세|직무발명\n보상금\n한도초과액", Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"pre_job_invention_over_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종전\n과세\n계|종전\n과세\n계",                       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_tot_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        
                        {Header:"종전 비과세|국외\n근로",      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_notax_abroad_mon",          KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종전 비과세|야간근로\n(생산)", Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_notax_work_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종전 비과세|보육\n수당",      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_notax_baby_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종전 비과세|출산\n지원금",      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_notax_child_birth_mon",     KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종전 비과세|연구보조비\n(H09)", Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_notax_research_mon",        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종전 비과세|취재\n수당",       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_notax_reporter_mon",		         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종전 비과세|식대",            Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_notax_food_mon",          KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종전 비과세|수련보조\n수당",    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_notax_train_mon",		         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종전 비과세|직무발명",         Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_job_invention_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종전 비과세|외국인\n근로",      Type:"AutoSum",         Hidden:1,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_notax_forn_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        //F_CPN_YEA_PRE_NOTAX_NEW 기타비과세에 포함되어 있음. 표시내용동기화 = [세금모의계산], [계산내역], [계산내역(관리자)], [정산계산내역조회] 
                        {Header:"종전 비과세|그밖의\n비과세",        Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_notax_ext_mon",		         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종전\n비과세\n계|종전\n비과세\n계",  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_notax_tot_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                                                
                        {Header:"주현 과세|급여액",                Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_pay_mon",                  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현 과세|상여액",                Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_bonus_mon",                KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현 과세|인정상여",               Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_etc_bonus_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현 과세|주식매수\n선택권\n행사이익", Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"curr_stock_buy_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현 과세|우리사주\n조합\n인출금",    Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"curr_stock_union_mon",          KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현 과세|임원\n퇴직소득\n한도초과액", Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"curr_imwon_ret_over_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현 과세|직무발명\n보상금\n한도초과액", Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"curr_job_invention_over_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현\n과세\n계|주현\n과세\n계",      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_tot_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        
                        {Header:"주현 비과세|국외\n근로",            Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_notax_abroad_mon",         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현 비과세|생산\n(야간근로)",       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_notax_work_mon",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현 비과세|보육\n수당",            Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_notax_baby_mon",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현 비과세|출산\n지원금",            Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_notax_child_birth_mon",    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현 비과세|연구보조비\n(H09)",      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_notax_research_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현 비과세|취재\n수당",            Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"notax_reporter_mon",		         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현 비과세|식대",                 Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"notax_food_mon",			     KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현 비과세|수련보조\n수당",         Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"notax_train_mon",		         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현 비과세|직무발명",              Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_job_invention_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현 비과세|외국인\n근로",           Type:"AutoSum",         Hidden:1,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_notax_forn_mon",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        //F_CPN_YEA_ETC_NOTAX_MON_NEW 기타비과세에 포함되어 있음. 표시내용동기화 = [세금모의계산], [계산내역], [계산내역(관리자)], [정산계산내역조회] 
                        {Header:"주현 비과세|그밖의비과세",            Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"notax_ext_mon",		         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현 비과세|기타비과세\n(미신고)",     Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"notax_etc_mon",		     KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현 비과세|차량비과세\n(미신고)",     Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"notax_car_mon",		         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현 비과세|일직료\n(미신고)",        Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"notax_nightduty_mon",		     KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현 비과세|위탁보육료\n(미신고)",        Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"notax_foster_mon",		     KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현\n비과세\n계|주현\n비과세\n계",    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_notax_tot_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주현비과세계\n - 미신고\n = [계산내역]|주현비과세계\n - 미신고\n = [계산내역]",  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_notax_tot_mon_calc",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        
                        /*
                        {Header:"종합 (주현+종전)|과세\n급여총액",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pay_mon",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종합 (주현+종전)|과세\n상여총액",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"bonus_mon",                     KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종합 (주현+종전)|과세\n인정상여",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"etc_bonus_mon",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종합 (주현+종전)|과세\n주식매수\n선택권\n행사이익",            Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"stock_buy_mon",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종합 (주현+종전)|과세\n우리사주\n조합\n인출금",                Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"stock_union_mon",               KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종합 (주현+종전)|과세\n임원\n퇴직소득\n한도초과액",        Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"imwon_ret_over_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종합 (주현+종전)|과세\n직무발명\n보상금\n한도초과액",     Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"job_invention_over_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종합 (주현+종전)|과세계",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"tot_mon",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        */
                        {Header:"종합 (주현+종전)|비과세계\n미신고포함",        Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"notax_tot_mon",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종합 (주현+종전)|비과세계\n신고대상",         Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"notax_tot_mon_nts",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종합 (주현+종전)|감면소득계",               Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"b010_13_nts",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"종합 (주현+종전)|총급여\n(과세대상급여)",     Type:"AutoSum",         Hidden:0,  Width:85,    Align:"Right",     ColMerge:1,   SaveName:"taxable_pay_mon",               KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        
                        {Header:"근로소득공제|근로소득\n공제금액",            Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a000_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"근로소득공제|근로소득\n금액",               Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"income_mon",                    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },

                        {Header:"기본공제|본인공제",                       Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"a010_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"기본공제|배우자\n공제\n여부",               Type:"Text",            Hidden:0,  Width:50,    Align:"Center",    ColMerge:1,   SaveName:"a010_03_yn",                    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"기본공제|배우자\n공제\n공제액",              Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"a010_03",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"기본공제|부양가족\n공제\n인원",              Type:"AutoSum",         Hidden:0,  Width:50,    Align:"Right",     ColMerge:1,   SaveName:"a010_cnt",                      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"기본공제|부양가족\n공제\n공제액",             Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"a010_11",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },

                        {Header:"추가공제|경로우대\n공제\n인원",              Type:"AutoSum",         Hidden:0,  Width:50,    Align:"Right",     ColMerge:1,   SaveName:"a020_03_cnt",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"추가공제|경로우대\n공제\n공제액",             Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"a020_04",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"추가공제|장애인\n공제\n인원",                Type:"AutoSum",         Hidden:0,  Width:50,    Align:"Right",     ColMerge:1,   SaveName:"a020_05_cnt",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"추가공제|장애인\n공제\n공제액",               Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"a020_05",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"추가공제|부녀자\n공제\n여부",                Type:"Text",            Hidden:0,  Width:50,    Align:"Center",    ColMerge:1,   SaveName:"a020_07_yn",                    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"추가공제|부녀자\n공제\n공제액",               Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"a020_07",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"추가공제|한부모\n공제\n여부",                Type:"Text",            Hidden:0,  Width:50,    Align:"Center",    ColMerge:1,   SaveName:"a020_14_yn",                    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        {Header:"추가공제|한부모\n공제\n공제액",               Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"a020_14",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        
                        //국민연금
                        {Header:"연금보험료공제|국민연금\n보험",                Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a030_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        //기타연금
                        {Header:"연금보험료공제|공적연금보험\n공무원연금",         Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a030_11",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"연금보험료공제|공적연금보험\n군인연금",          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a030_12",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"연금보험료공제|공적연금보험\n사립학교\n교직원연금", Type:"AutoSum",         Hidden:0,  Width:110,    Align:"Right",     ColMerge:1,   SaveName:"a030_02",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"연금보험료공제|공적연금보험\n별정우체국\n연금",    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a030_13",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        
                        //보험료
                        {Header:"특별소득공제 보험료|건강보험\n공제",            Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a040_03",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"특별소득공제 보험료|고용보험\n공제",            Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a040_04",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        
                        //주택자금
                        {Header:"특별소득공제 주택자금\n주택임차차입금공제|기관",    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a070_14",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"특별소득공제 주택자금\n주택임차차입금공제|거주자",   Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a070_21",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        
                        {Header:"특별소득공제 주택자금 장기주택저당차입금 이자상환\n'11.12.31이전 차입금|10년이상",   Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a070_17",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"특별소득공제 주택자금 장기주택저당차입금 이자상환\n'11.12.31이전 차입금|15년이상",  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a070_15",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"특별소득공제 주택자금 장기주택저당차입금 이자상환\n'11.12.31이전 차입금|30년이상",                    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a070_16",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        <%//2024년 추가 사항 start%>
                        {Header:"특별소득공제 주택자금 장기주택저당차입금 이자상환\n'11.12.31이전 차입금|15년이상\n고정and비거치",         Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a070_22",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"특별소득공제 주택자금 장기주택저당차입금 이자상환\n'11.12.31이전 차입금|15년이상\n고정or비거치",           Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a070_23",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"특별소득공제 주택자금 장기주택저당차입금 이자상환\n'12.01.01이후 차입금|15년이상\n고정and비거치",   Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a070_24",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"특별소득공제 주택자금 장기주택저당차입금 이자상환\n'12.01.01이후 차입금|15년이상\n고정or비거치",   Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a070_25",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"특별소득공제 주택자금 장기주택저당차입금 이자상환\n'12.01.01이후 차입금|15년이상\n기타대출",     Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a070_26",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"특별소득공제 주택자금 장기주택저당차입금 이자상환\n'12.01.01이후 차입금|10년이상\n고정or비거치",   Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a070_27",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        <%//2024년 추가 사항 end%>
                        
                        {Header:"특별소득공제\n계|특별소득공제\n계",             Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a099_02",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        
                        //{Header:"표준공제",                           Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a099_01",               KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        
                        {Header:"차감소득금액|차감소득금액",                    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"blnce_income_mon",              KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        
                        // 그 밖의 소득공제
                        {Header:"그밖의소득공제|개인연금저축",                   Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_03",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"그밖의소득공제|소기업소상공인",                  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_30",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"그밖의소득공제|주택마련저축\n주택청약\n저축",       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_34",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"그밖의소득공제|주택마련저축\n주택청약\n종합저축",    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_31",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"그밖의소득공제|주택마련저축\n근로자\n주택마련저축",   Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_33",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"그밖의소득공제|주택마련저축\n주택마련\n저축",       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_35",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        
                        {Header:"그밖의소득공제|투자조합",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_07",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"그밖의소득공제|신용카드등",                     Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_23",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"그밖의소득공제|우리사주\n조합출연금",             Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_21",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"그밖의소득공제|우리사주\n(2014 이전)\n조합기부금", Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"a080_09_2014",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"그밖의소득공제|고용유지\n중소기업\n근로자",        Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"a100_37",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"그밖의소득공제|목돈안드는\n전세\n이자상환액",       Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"a100_38",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        {Header:"그밖의소득공제|장기집합투자\n증권저축",           Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"a100_40",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2014 추가
                        {Header:"그밖의소득공제|청년형\n장기집합투자\n증권저축",     Type:"AutoSum",         Hidden:0,  Width:120,    Align:"Right",     ColMerge:1,   SaveName:"a100_41",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2022 추가
                        {Header:"그밖의\n소득공제\n계|그밖의\n소득공제\n계",       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_99",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        
                        {Header:"소득공제\n종합한도\n초과액|소득공제\n종합한도\n초과액", Type:"AutoSum",         Hidden:0,  Width:140,    Align:"Right",     ColMerge:1,   SaveName:"limit_over_mon",                KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        {Header:"과세표준|과세표준",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"tax_base_mon",                  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"산출세액|산출세액",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"clclte_tax_mon",                KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        
                        {Header:"세액감면|소득세법",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b010_14",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액감면|조세특례\n제한법\n제30조",             Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"b010_16",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액감면|조세특례\n제한법\n제30조 제외",      Type:"AutoSum",         Hidden:1,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"b010_15",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액감면|조세특례\n제한법\n제30조 제외",      Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"ex_b010_16",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액감면|조세조약",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b010_17",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"감면세액\n계|감면세액\n계",                   Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b010_13",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        
                        {Header:"세액공제|근로소득\n세액공제",                  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b000_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액공제|결혼세액\n공제\n공제액",               Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"b002_10",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        <%//2015-04-23 추가 수정 start %>
                        {Header:"세액공제|자녀세액\n공제\n인원",                Type:"AutoSum",         Hidden:0,  Width:50,    Align:"Right",     ColMerge:1,   SaveName:"b000_10_cnt",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액공제|자녀세액\n공제\n공제액",               Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"b000_10",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액공제|자녀세액\n공제\n6세이하\n인원",         Type:"AutoSum",         Hidden:0,  Width:50,    Align:"Right",     ColMerge:1,   SaveName:"b001_20_cnt",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액공제|자녀세액\n공제\n6세이하\n공제액",        Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"b001_20",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액공제|자녀세액\n공제\n출산/입양\n인원",        Type:"AutoSum",         Hidden:0,  Width:55,    Align:"Right",     ColMerge:1,   SaveName:"b001_30_cnt",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액공제|자녀세액\n공제\n출산/입양\n공제액",       Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"b001_30",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        <%//2015-04-23 추가 수정 end %>
                        //연금계좌
                        {Header:"세액공제|연금계좌\n과학기술인공제",               Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a030_04",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        {Header:"세액공제|연금계좌\n퇴직연금공제",                Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a030_03",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        {Header:"세액공제|연금계좌\n연금저축공제",                Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_05",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        /*
                        {Header:"보장성보험공제",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a040_05",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"장애인전용보험공제",                    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a040_07",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        */
                        <%//2015-04-23 추가 수정 start %>
                        {Header:"특별세액공제|보장성보험료\n일반",            Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a040_05",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"특별세액공제|보장성보험료\n장애인전용",        Type:"AutoSum",         Hidden:0,  Width:80,    Align:"Right",     ColMerge:1,   SaveName:"a040_07",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        <%//2015-04-23 추가 수정 end %>
                        //의료비
                        /*
                        {Header:"장애인 의료비",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a050_20",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        {Header:"기타 의료비",                       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a050_21",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        */
                        {Header:"특별세액공제|의료비",                     Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a050_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        //교육비
                        /*
                        {Header:"장애인 교육비",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a060_20",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        {Header:"기타 교육비",                       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a060_21",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        */
                        {Header:"특별세액공제|교육비",                     Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a060_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        
                        //기부금
                        {Header:"특별세액공제|기부금\n정치자금\n10만원 이하",   Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b010_05",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"특별세액공제|기부금\n정치자금\n10만원 초과",   Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a080_05",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"특별세액공제|기부금\n고향사랑\n10만원 이하",   Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a080_15",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"특별세액공제|기부금\n고향사랑\n10만원 초과",   Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a080_17",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"특별세액공제|기부금\n법정",                Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a080_03",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"특별세액공제|기부금\n우리사주조합",          Type:"AutoSum",         Hidden:0,  Width:110,    Align:"Right",     ColMerge:1,   SaveName:"a080_09",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"특별세액공제|기부금\n지정",                Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a080_13",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        
                        {Header:"특별세액\n공제계|특별세액\n공제계",          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b013_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"표준세액\n공제|표준세액\n공제",             Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a099_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        
                        {Header:"세액공제|납세조합",                       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b010_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액공제|주택자금\n이자세액",               Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b010_03",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액공제|외국납부",                       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b010_07",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액공제|월세",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a070_10",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액공제계|세액공제계",                    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"tax_ded_mon",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        
                        {Header:"세액명세 결정세액|소득세",                  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"fin_income_tax",                KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액명세 결정세액|지방세",                  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"fin_inbit_tax_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액명세 결정세액|농특세",                  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"fin_agrcl_tax_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액명세 기납부(종전)|소득세",               Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_income_tax_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액명세 기납부(종전)|지방세",               Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_inbit_tax_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액명세 기납부(종전)|농특세",               Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_agrcl_tax_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액명세 기납부(주현)|소득세",               Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_income_tax_mon",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액명세 기납부(주현)|지방세",               Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_inbit_tax_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액명세 기납부(주현)|농특세",               Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_agrcl_tax_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액명세 납부특례|소득세",                  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"c015_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액명세 납부특례|지방세",                  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"c015_02",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액명세 납부특례|농특세",                  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"c015_03",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액명세 차감징수|소득세",                  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"blc_income_tax_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액명세 차감징수|지방세",                  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"blc_inbit_tax_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액명세 차감징수|농특세",                  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"blc_agrcl_tax_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액명세\n실효세율|세액명세\n실효세율",        Type:"Float",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"eff_tax_rate",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:1,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
                        
                        
                    ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        //작업구분
        <%-- 속도저하 때문에 아래와 같이 변경 20240710
        var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00303"), "전체");
        var payPeopleStatus = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00125"), "전체");
        $("#searchAdjustType").html(adjustTypeList[2]);
        sheet1.SetColProperty("pay_people_status", {ComboText:"|"+payPeopleStatus[0], ComboCode:"|"+payPeopleStatus[1]}); --%>
		//sheet1.SetColProperty("adjust_type_nm",  	{ComboText:"|연말정산|퇴직정산", ComboCode:"|1|3"});
		//sheet1.SetColProperty("gubun", 	            {ComboText:"|최종|수정(이력)",        ComboCode:"|F|H"});
        <%--sheet1.SetColProperty("pay_people_status",  {ComboText:"|작업대상|작업완료|재계산",  ComboCode:"|P|J|M"});--%>
        //sheet1.SetColProperty("pay_people_status",  {ComboText:"|작업대상|작업완료",  ComboCode:"|P|J"});
        //sheet1.SetColProperty("except_yn",          {ComboText:"|N|Y",                ComboCode:"|N|Y"});
        <%-- var foreignTaxType = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00170"), "전체"); // 외국인세금계산유형 --%>
        //sheet1.SetColProperty("foreign_tax_type", {ComboText:"|"+foreignTaxType[0], ComboCode:"|"+foreignTaxType[1]});
        
        //작업구분
        var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00303"), "전체");
        var payPeopleStatus = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00125"), "전체");
        var foreignTaxType = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00170"), "전체"); // 외국인세금계산유형
        $("#searchAdjustType").html(adjustTypeList[2]);

        sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
        sheet1.SetColProperty("pay_people_status", {ComboText:"|"+payPeopleStatus[0], ComboCode:"|"+payPeopleStatus[1]});
        sheet1.SetColProperty("except_yn", {ComboText:"N|Y", ComboCode:"N|Y"});
        sheet1.SetColProperty("foreign_tax_type", {ComboText:"|"+foreignTaxType[0], ComboCode:"|"+foreignTaxType[1]});
        sheet1.SetColProperty("gubun", 	            {ComboText:"|최종|수정(이력)",        ComboCode:"|F|H"});
        sheet1.SetColProperty("adjust_type_nm",  	{ComboText:"|연말정산|퇴직정산", ComboCode:"|1|3"});
        
		$(window).smartresize(sheetResize); sheetInit();

        // 사업장(권한 구분)
		var ssnSearchType  = "<%=ssnSearchType%>";
		var bizPlaceCdList = "";

		if(ssnSearchType == "A"){
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
		}else{
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}
		 
        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);
        
        <%-- 속도저하 때문에 initPage() 사용 하지 않음. --%>
		var searchDivPage = "<option value=''>전체</option>";
		var totalCount    = 10000; // 총건수
    	var divPage       = $("#searchDivPage").val();   // 100건씩 페이징
    	var maxPage       = 0;     // 전체 페이지
		if(totalCount > 0 && divPage > 0) {
			maxPage = Math.floor(totalCount/divPage)+1;
		}
   	    if(maxPage > 0) {
			for(i=1; i<=maxPage; i++) {
				searchDivPage = searchDivPage + "<option value='"+i+"' >"+((i-1)*divPage+1)+" ~ "+i*divPage+"</option>";
			}
		}
		$("#searchPage").html(searchDivPage); //전체로 초기 세팅
		
		<% if ("Y".equals(reCalc)) { %>
		    //sheet1.SetColHidden("adjust_type", 0);
			sheet1.SetColHidden("gubun", 0);
			sheet1.SetColHidden("re_seq", 0);
			
			$("#sSearchReSeq").removeClass("hide");
   			
   			<%-- 속도저하 때문에 아래와 같이 변경 20240710
   			//해당 년도의 재계산 차수 리스트 조회
   			var strUrl = "<%=jspPath%>/yeaCalcSearch/yeaCalcSearchRst.jsp?cmd=selectYeaReSeqList&searchYear=<%=yeaYear%>" ;
   			var searchReSeq = stfConvCode( codeList(strUrl,"") , "");   			
   			$("#searchReSeq").html(searchReSeq[2]); //전체로 초기 세팅 --%>
   			var searchReSeq = "";
   			for (var i=1; i<11; i++) { // 디폴트로 10회차까지 표시
   				searchReSeq = searchReSeq + "<option value='" + i + "'>" + i + "회차</option>";
   			}
   			$("#searchReSeq").html(searchReSeq); //전체로 초기 세팅
   			$("#searchReSeq").select2({
				placeholder: "전체"
				, maximumSelectionSize:5
			});
		<% } %>

        //doAction1("Search");
    });

    $(function() {

        $("#searchWorkYy").bind("keyup",function(event){
            makeNumber(this,"A");
            if( event.keyCode == 13){
                doAction1("Search");
            }
        });

        $("#searchSbNm").bind("keyup",function(event){
            if( event.keyCode == 13){
                doAction1("Search");
            }
        });

        $("#searchPaySym").mask("1111-11");
        $("#searchPayEym").mask("1111-11");
	    $("#searchPaySym").datepicker2({ymonly:true});
	    $("#searchPayEym").datepicker2({ymonly:true});
	    $("#searchPaymentSymd").datepicker2();
        $("#searchPaymentEymd").datepicker2();

		$("#searchPaySym,#searchPayEym,searchPaymentSymd,searchPaymentEymd").bind("keyup",function(event){
			readonly="readonly"
			if( event.keyCode == 13){
				if($(this).val().length > 6) {
					doAction1("Search");
				}
			}
		});
    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
        	var param = $("#sheetForm").serialize() 
        	            + "&mSearchReSeq="+($("#searchReSeq").val()==null?"":getMultiSelect($("#searchReSeq").val()));
        	sheet1.DoSearch( "<%=jspPath%>/yeaCalcSearch/yeaCalcSearchRst.jsp?cmd=selectYeaCalcSearch", param );
            break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
            sheet1.Down2Excel(param);
            break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
        	if($("#searchAdjustType").val() == "1"){
        		sheet1.SetColHidden("pay_action_nm",1);
        	}else{
        		sheet1.SetColHidden("pay_action_nm",0);
        	}
            alertMessage(Code, Msg, StCode, StMsg);
            //sheetResize();
            
            sheet1.FitSize(1, 1);
            
        } catch(ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

	//	"최종" 일 경우 차수를 선택하는 selectbox 비활성화 처리. (차수는 수정(이력) 에서만 부여되기 때문에 최종에서는 의미가 없음)
    function searchGubun_onChange() {
		var searchGubun = $("#searchGubun").val();
		
    	/* searchReSeq 콤보박스는 Select2 플러그인을 사용하여 다중선택콤보로 커스텀 UI가 적용되어 있음. (위 338 라인)
    	---------------------------------------------------------------------------------------------
    	<select> 요소에 스타일과 기능을 추가하면 기본적으로 HTML <select> 요소의 UI가 Select2의 커스텀 UI로 대체되므로
    	disabled를 설정하려면 Select2 API를 통해 해당 상태를 전달해야 함. 
    	(Select2는 자체적으로 UI를 관리하며, 기본 <select> 요소의 disabled 상태를 감지하지 않음.) */
		if(searchGubun == "F") {
			$('#searchReSeq').val(null).trigger('change'); // 선택된 옵션을 초기화하고 Select2에 변경사항을 알림
			$('#searchReSeq').prop('disabled', true);      // 기본 select 요소 비활성화
		} else {
			$('#searchReSeq').prop('disabled', false);
		}
		
		// 설정한 내용을 기준으로 Select2 인스턴스를 다시 초기화하여 반영
   		$("#searchReSeq").select2({
		  	  placeholder: "전체" // 아무것도 선택되지 않았을 때 표시할 텍스트
			, maximumSelectionSize:5
		});
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    	<input type="hidden" id="searchDivPage" name="searchDivPage" value="100" />
    	<input type="hidden" id="menuNm" name="menuNm" value="" />
        <input type="hidden" id="reCalc" name="reCalc" value="<%=reCalc%>"/>
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                        <td><span>귀속년도</span>
							<%
							if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
							%>
								<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text center" maxlength="4" style="width:35px" value="<%=yeaYear%>" />
							<%}else{%>
								<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text center readonly" maxlength="4" style="width:35px" value="<%=yeaYear%>" readonly/>
							<%}%>
							
							&nbsp;
							<span>정산구분</span>
                            <select id="searchAdjustType" name ="searchAdjustType" class="box">
                            	<option value="">전체</option>
                            	<option value="1">연말정산</option>
                            	<option value="3">퇴직정산</option>
                            </select>  
                            &nbsp;    
	                        <span id="sSearchReSeq" name="sSearchReSeq" class="hide">
	                            <span>재정산</span>
	                            <select id="searchGubun" name ="searchGubun" class="box" onChange="javascript:searchGubun_onChange()">
	                            	<option value="">전체</option>
	                            	<option value="F">최종</option>
	                            	<option value="H">수정(이력)</option>
	                            </select>               
	                            <select id="searchReSeq" name="searchReSeq" multiple>
								</select>
	                        </span>
							    
							&nbsp;                 
                            <span>계산상태</span>
                            <select id="searchPayPeopleStatus" name ="searchPayPeopleStatus" class="box">
                                <option value="">전체</option>
                                <option value="P">작업대상</option>
                                <option value="J">작업완료</option>
                                <%--<option value="M">재계산</option> --%>
                            </select>
                            
                            &nbsp;
							<span>조회구분</span>
                            <select id="searchStdMon" name ="searchStdMon" class="box">
                                <option value="">(세액)공제액</option>
                                <option value="GET_STD_MON">공제대상액</option>
                            </select>
                            
							&nbsp;
							<span>사업장</span>
		                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box"></select>
		                
							&nbsp;
							<span>사번/성명</span>
                            <input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
                           
                        </td>
                    </tr>
                    <tr>
                        <td>
                        	<span id="ymTd">귀속년월</span>
	                        	<input id="searchPaySym" name="searchPaySym" class="date2" value="<%=yeaYear%>-01"/>~
								<input id="searchPayEym" name="searchPayEym" class="date2" value="<%=yeaYear%>-12"/>
							
							&nbsp;
							<span>지급일자</span>
	                        	<input id="searchPaymentSymd" name="searchPaymentSymd" class="date2" value="<%=yeaYear%>-01-01"/>~
								<input id="searchPaymentEymd" name="searchPaymentEymd" class="date2" value="<%=Integer.parseInt(yeaYear) + 1 %>-01-31"/>
                                   
                            &nbsp;
							<span>신고제외여부</span>
                            <select id="searchExceptYn" name ="searchExceptYn" class="box">
                                <option value="">전체</option>
                                <option value="Y">Y</option>
                                <option value="N">N</option>
                            </select>
                        
                            &nbsp;
							<span>Page</span>
                            <select id="searchPage" name ="searchPage" class="box"></select>
                            
                            &nbsp;&nbsp
                            <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li id="txt" class="txt">정산계산내역조회</li>
            <li class="btn">
                <a href="javascript:doAction1('Down2Excel')"    class="basic btn-download authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>

    <script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>