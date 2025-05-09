<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>정산계산내역조회</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
    
    $(function() {  
    
        $("#searchWorkYy").val("<%=yeaYear%>");
        
        var initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:5, DataRowMerge:0};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
                        {Header:"No",       Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
                        {Header:"년도",                              Type:"Text",            Hidden:0,  Width:60,     Align:"Center",    ColMerge:1,   SaveName:"work_yy",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"정산구분",                          Type:"Text",            Hidden:1,  Width:100,    Align:"Center",    ColMerge:1,   SaveName:"adjust_type",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"사번",                              Type:"Text",            Hidden:0,  Width:80,     Align:"Center",    ColMerge:1,   SaveName:"sabun",                         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"성명",                              Type:"Text",            Hidden:0,  Width:80,     Align:"Center",    ColMerge:1,   SaveName:"name",                          KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"부서",                              Type:"Text",            Hidden:0,  Width:100,    Align:"Center",    ColMerge:1,   SaveName:"org_nm",                        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"사업장",                            Type:"Text",            Hidden:0,  Width:80,     Align:"Center",    ColMerge:1,   SaveName:"business_place_nm",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"입사일",                            Type:"Text",            Hidden:0,  Width:100,    Align:"Center",    ColMerge:1,   SaveName:"emp_ymd",                       KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"퇴사일",                            Type:"Text",            Hidden:0,  Width:100,    Align:"Center",    ColMerge:1,   SaveName:"ret_ymd",                       KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },                      {Header:"급여액_전",                        Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_pay_mon",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"상여액_전",                         Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_bonus_mon",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"인정상여_전",                       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_etc_bonus_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주식매수선택권행사이익_전",         Type:"AutoSum",         Hidden:0,  Width:150,    Align:"Right",     ColMerge:1,   SaveName:"pre_stock_buy_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"우리사주조합인출금_전",             Type:"AutoSum",         Hidden:0,  Width:140,    Align:"Right",     ColMerge:1,   SaveName:"pre_stock_union_mon",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"임원퇴직소득금액한도초과액_전",     Type:"AutoSum",         Hidden:0,  Width:170,    Align:"Right",     ColMerge:1,   SaveName:"pre_imwon_ret_over_mon",        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"국외근로_전",                       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_notax_abroad_mon",          KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"야간근로_전",                       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_notax_work_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"출산보육_전",                       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_notax_baby_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"외국인근로_전",                     Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_notax_forn_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"연구보조비_전",                     Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_notax_research_mon",        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"비과세계_전",                       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_notax_tot_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"급여액_현",                         Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_pay_mon",                  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"상여액_현",                         Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_bonus_mon",                KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"인정상여_현",                       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_etc_bonus_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주식매수선택권행사이익_현",         Type:"AutoSum",         Hidden:0,  Width:150,    Align:"Right",     ColMerge:1,   SaveName:"curr_stock_buy_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"우리사주조합인출금_현",             Type:"AutoSum",         Hidden:0,  Width:140,    Align:"Right",     ColMerge:1,   SaveName:"curr_stock_union_mon",          KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"임원퇴직소득금액한도초과액_현",     Type:"AutoSum",         Hidden:0,  Width:170,    Align:"Right",     ColMerge:1,   SaveName:"curr_imwon_ret_over_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"국외근로_현",                       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_notax_abroad_mon",         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"야간근로_현",                       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_notax_work_mon",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"출산보육_현",                       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_notax_baby_mon",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"외국인근로_현",                     Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_notax_forn_mon",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"연구보조비_현",                     Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_notax_research_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"비과세계_현",                       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_notax_tot_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"급여총액",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pay_mon",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"상여총액",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"bonus_mon",                     KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"인정상여",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"etc_bonus_mon",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주식매수선택권행사이익",            Type:"AutoSum",         Hidden:0,  Width:140,    Align:"Right",     ColMerge:1,   SaveName:"stock_buy_mon",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"우리사주조합인출금",                Type:"AutoSum",         Hidden:0,  Width:110,    Align:"Right",     ColMerge:1,   SaveName:"stock_union_mon",               KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"임원퇴직소득금액한도초과액",        Type:"AutoSum",         Hidden:0,  Width:160,    Align:"Right",     ColMerge:1,   SaveName:"imwon_ret_over_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"비과세계",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"notax_tot_mon",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"총급여",                            Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"taxable_pay_mon",               KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"근로소득공제",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a000_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"근로소득금액",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"income_mon",                    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"본인공제",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a010_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"배우자여부",                        Type:"Text",            Hidden:0,  Width:100,    Align:"Center",    ColMerge:1,   SaveName:"a010_03_yn",                    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"배우자공제",                        Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a010_03",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"부양자수",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a010_cnt",                      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"부양가족공제",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a010_11",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"경로자수",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a020_03_cnt",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"경로우대공제",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a020_04",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"장애자수",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a020_05_cnt",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"장애인공제",                        Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a020_05",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"부녀자여부",                        Type:"Text",            Hidden:0,  Width:100,    Align:"Center",    ColMerge:1,   SaveName:"a020_07_yn",                    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"부녀자공제",                        Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a020_07",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"한부모여부",                        Type:"Text",            Hidden:0,  Width:100,    Align:"Center",    ColMerge:1,   SaveName:"a020_14_yn",                    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        {Header:"한부모공제",                        Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a020_14",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        {Header:"연금보험공제",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a030_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        //기타연금
                        {Header:"공무원연금",                        Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a030_11",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"군인연금",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a030_12",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"사립학교교직원연금",                Type:"AutoSum",         Hidden:0,  Width:110,    Align:"Right",     ColMerge:1,   SaveName:"a030_02",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"별정우체국연금",                    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a030_13",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        //보험료
                        {Header:"건강보험공제",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a040_03",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"고용보험공제",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a040_04",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        //주택자금
                        {Header:"주택임차차입금공제_기관",           Type:"AutoSum",         Hidden:0,  Width:140,    Align:"Right",     ColMerge:1,   SaveName:"a070_14",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주택임차차입금공제_거주자",         Type:"AutoSum",         Hidden:0,  Width:150,    Align:"Right",     ColMerge:1,   SaveName:"a070_21",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"장기주택저당차입금이자_15년미만",   Type:"AutoSum",         Hidden:0,  Width:180,    Align:"Right",     ColMerge:1,   SaveName:"a070_17",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"장기주택저당차입금이자_(15~29년)",  Type:"AutoSum",         Hidden:0,  Width:190,    Align:"Right",     ColMerge:1,   SaveName:"a070_15",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"장기주택저당차입금이자_30년이상",                    Type:"AutoSum",         Hidden:0,  Width:190,    Align:"Right",     ColMerge:1,   SaveName:"a070_16",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"장기주택저당차입금이자_고정금리/비거치상환",         Type:"AutoSum",         Hidden:0,  Width:240,    Align:"Right",     ColMerge:1,   SaveName:"a070_22",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"장기주택저당차입금이자_기타 대출",                   Type:"AutoSum",         Hidden:0,  Width:180,    Align:"Right",     ColMerge:1,   SaveName:"a070_23",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        <%//2015년 추가 사항 start%>
                        {Header:"장기주택저당차입금이자_15년이상 고정&비거치 상환",   Type:"AutoSum",         Hidden:0,  Width:260,    Align:"Right",     ColMerge:1,   SaveName:"a070_24",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"장기주택저당차입금이자_15년이상 고정/비거치 상환",   Type:"AutoSum",         Hidden:0,  Width:260,    Align:"Right",     ColMerge:1,   SaveName:"a070_25",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"장기주택저당차입금이자_15년이상 기타대출",           Type:"AutoSum",         Hidden:0,  Width:240,    Align:"Right",     ColMerge:1,   SaveName:"a070_26",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"장기주택저당차입금이자_10년이상 고정/비거치 상환",   Type:"AutoSum",         Hidden:0,  Width:260,    Align:"Right",     ColMerge:1,   SaveName:"a070_27",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        <%//2015년 추가 사항 end%>
                        {Header:"기부금(이월분)",                    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a080_20",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"특별공제계",                        Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a099_02",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        //{Header:"표준공제",                           Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a099_01",               KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"차감소득금액",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"blnce_income_mon",              KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        // 그 밖의 소득공제
                        {Header:"개인연금저축",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_03",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"소기업소상공인",                    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_30",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주택청약저축",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_34",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주택청약종합저축",                  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_31",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"근로자주택마련저축",                Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_33",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주택마련저축",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_35",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"투자조합",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_07",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"신용카드등",                        Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_23",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"우리사주",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_21",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"우리사주조합기부금(2014이전)",                Type:"AutoSum",         Hidden:0,  Width:110,    Align:"Right",     ColMerge:1,   SaveName:"a080_09_2014",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"고용유지중소기업근로자",            Type:"AutoSum",         Hidden:0,  Width:130,    Align:"Right",     ColMerge:1,   SaveName:"a100_37",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"목돈 안드는 전세 이자상환액",       Type:"AutoSum",         Hidden:0,  Width:160,    Align:"Right",     ColMerge:1,   SaveName:"a100_38",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        {Header:"장기집합투자증권저축",              Type:"AutoSum",         Hidden:0,  Width:120,    Align:"Right",     ColMerge:1,   SaveName:"a100_40",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2014 추가           
                        {Header:"그밖의소득공제계",                  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_99",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"특별공제 종합한도 초과액",          Type:"AutoSum",         Hidden:0,  Width:140,    Align:"Right",     ColMerge:1,   SaveName:"limit_over_mon",                KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        {Header:"과세표준",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"tax_base_mon",                  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"산출세액",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"clclte_tax_mon",                KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"소득세법",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b010_14",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"조세특례제한법_(제30조 제외)",      Type:"AutoSum",         Hidden:0,  Width:170,    Align:"Right",     ColMerge:1,   SaveName:"b010_15",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"조세특례제한법_제30조",             Type:"AutoSum",         Hidden:0,  Width:130,    Align:"Right",     ColMerge:1,   SaveName:"b010_16",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"조세조약",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b010_17",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"감면세액계",                        Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b010_13",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"근로소득세액공제",                  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b000_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        <%//2015-04-23 추가 수정 start %>
                        {Header:"자녀수",                             Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b000_10_cnt",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"자녀세액공제",                       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b000_10",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"6세이하 자녀수",                     Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b001_20_cnt",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"6세 이하 세액공제",                  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b001_20",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"출산/입양자 수",                     Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b001_30_cnt",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"출산/입양 세액공제",                 Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b001_30",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        <%//2015-04-23 추가 수정 end %>
                        //연금계좌
                        {Header:"과학기술인공제",                    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a030_04",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        {Header:"퇴직연금공제",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a030_03",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        {Header:"연금저축공제",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a100_05",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        /*
                        {Header:"보장성보험공제",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a040_05",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"장애인전용보험공제",                    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a040_07",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        */
                        <%//2015-04-23 추가 수정 start %>
                        {Header:"보장성보험료",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a040_05",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"장애인 전용 보장성보험료",          Type:"AutoSum",         Hidden:0,  Width:150,    Align:"Right",     ColMerge:1,   SaveName:"a040_07",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        <%//2015-04-23 추가 수정 end %>
                        //의료비
                        /*
                        {Header:"장애인 의료비",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a050_20",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        {Header:"기타 의료비",                       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a050_21",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        */
                        {Header:"의료비",                            Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a050_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        //교육비
                        /*
                        {Header:"장애인 교육비",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a060_20",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        {Header:"기타 교육비",                       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a060_21",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        */
                        {Header:"교육비",                            Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a060_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }, // 2013 추가
                        //기부금
                        {Header:"정치자금기부금 10만원 이하",        Type:"AutoSum",         Hidden:0,  Width:150,    Align:"Right",     ColMerge:1,   SaveName:"b010_05",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"정치자금기부금 10만원 초과",        Type:"AutoSum",         Hidden:0,  Width:150,    Align:"Right",     ColMerge:1,   SaveName:"a080_05",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"법정기부금",                        Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a080_03",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"우리사주조합기부금",                Type:"AutoSum",         Hidden:0,  Width:110,    Align:"Right",     ColMerge:1,   SaveName:"a080_09",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"지정기부금",                        Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a080_13",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"특별세액공제계",                    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b013_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"표준세액공제",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a099_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"납세조합",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b010_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"주택자금이자세액",                  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b010_03",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"외국납부",                          Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"b010_07",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"월세",                              Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a070_10",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"세액공제계",                        Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"tax_ded_mon",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"결정소득세",                        Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"fin_income_tax",                KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"결정\n지방소득세",                  Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"fin_inbit_tax_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"결정농특세",                        Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"fin_agrcl_tax_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },          
                        {Header:"소득세_전",                         Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_income_tax_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"지방소득세_전",                     Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_inbit_tax_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"농특세_전",                         Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"pre_agrcl_tax_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },          
                        {Header:"소득세_현",                         Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_income_tax_mon",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"지방소득세_현",                     Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_inbit_tax_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"농특세_현",                         Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"curr_agrcl_tax_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"납부특례소득세",                    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"c015_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"납부특례지방소득세",                Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"c015_02",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"납부특례농특세",                    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"c015_03",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"차감징수소득세",                    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"blc_income_tax_mon",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"차감징수\n지방소득세",              Type:"AutoSum",         Hidden:0,  Width:120,    Align:"Right",     ColMerge:1,   SaveName:"blc_inbit_tax_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"차감징수농특세",                    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"blc_agrcl_tax_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"작업일자",                          Type:"Text",            Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"chk_date",                      KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"작업자사번",                        Type:"Text",            Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"chkid",                         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
                    ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
        
        //작업구분
        var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00303"), "");
           
        $("#searchAdjustType").html(adjustTypeList[2]);
        
        // 사업장
        var bizPlaceCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getBizPlaceCdList") , "전체");
        
        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);
        
        $(window).smartresize(sheetResize); sheetInit();
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
        
    });
    
    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":   
            sheet1.DoSearch( "<%=jspPath%>/yeaCalcSearch/yeaCalcSearchRst.jsp?cmd=selectYeaCalcSearch", $("#sheetForm").serialize() );
            break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
            sheet1.Down2Excel(param);
            break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { 
            alertMessage(Code, Msg, StCode, StMsg);
            sheetResize();
        } catch(ex) { 
            alert("OnSearchEnd Event Error : " + ex); 
        }
    }
    
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                        <td>
                            <span>년도</span>
                            <input id="searchWorkYy" name ="searchWorkYy" type="text" class="text" maxlength="4" style="width:35px" value="<%=yeaYear%>" />
                        </td>
                        <td>
                            <span>작업구분</span>
                            <select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select> 
                        </td>
		                <td>
		                    <span>사업장</span>
		                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box"></select>
		                </td>
                        <td>
                            <span>사번/성명</span>
                            <input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
                        </td>
                        <td> 
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
                <a href="javascript:doAction1('Down2Excel')"    class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    
    <script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>