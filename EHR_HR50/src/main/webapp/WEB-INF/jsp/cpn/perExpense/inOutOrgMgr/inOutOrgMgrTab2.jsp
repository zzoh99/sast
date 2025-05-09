<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>전표조회</title>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

    <script type="text/javascript">
        var gPRow = "";
        var pGubun = "";

        $(function() {

            $("input[type='text']").keydown(function(event){
                if(event.keyCode == 27){
                    return false;
                }
            });

            $("#pSearchYm").val($("#searchYm", parent.document).val().replace(/-/g,""));

            var initdata1 = {};
            initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
            initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

            initdata1.Cols = [
                {Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
                {Header:"삭제",				Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
                {Header:"상태",				Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

                {Header:"Slip Name",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"Accounting\nDate",	Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"accountingDate",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"Product\nCode",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"Location\nCode",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"Depart\nCode",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment3",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"Account\nCode",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment4",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"Meaning",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"meaning",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"Dr Amount",		Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"accountedDr",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"Cr Amount",		Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"accountedCr",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"Comments",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference27",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"Transfer\nDate",	Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"transferDate",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"Transfer\nFlag",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"transferFlag",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },


                {Header:"interfaceId",						Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"interfaceId",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"assignmentSetId",					Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"assignmentSetId",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"lineSeq",							Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"lineSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"invoiceType",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"invoiceType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
                {Header:"status",							Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"status",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
                {Header:"currencyCode",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"currencyCode",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
                {Header:"dateCreated",						Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"dateCreated",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"createdBy",						Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"createdBy",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"actualFlag",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"actualFlag",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
                {Header:"userJeCategoryName",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"userJeCategoryName",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"userJeSourceName",					Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"userJeSourceName",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"currencyConversionDate",			Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"currencyConversionDate",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"encumbranceTypeId",				Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"encumbranceTypeId",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"budgetVersionId",					Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"budgetVersionId",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"userCurrencyConversionType",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"userCurrencyConversionType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
                {Header:"currencyConversionRate",			Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"currencyConversionRate",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"averageJournalFlag",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"averageJournalFlag",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
                {Header:"originatingBalSegValue",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"originatingBalSegValue",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment1",							Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment2",							Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment3",							Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment3",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment4",							Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment4",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment5",							Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment5",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment6",							Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment6",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment7",							Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment7",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment8",							Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment8",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment9",							Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment9",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment10",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment10",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment11",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment11",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment12",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment12",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment13",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment13",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment14",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment14",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment15",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment15",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment16",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment16",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment17",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment17",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment18",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment18",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment19",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment19",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment20",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment20",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment21",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment21",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment22",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment22",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment23",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment23",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment24",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment24",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment25",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment25",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment26",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment26",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment27",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment27",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment28",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment28",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment29",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment29",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"segment30",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"segment30",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
                {Header:"enteredDr",						Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"enteredDr",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"enteredCr",						Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"enteredCr",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"transactionDate",					Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"transactionDate",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"reference1",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"reference2",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:240 },
                {Header:"reference3",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference3",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"reference4",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference4",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"reference5",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference5",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:240 },
                {Header:"reference6",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference6",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"reference7",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference7",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"reference8",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference8",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"reference9",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference9",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"reference10",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference10",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:240 },
                {Header:"reference11",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference11",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:240 },
                {Header:"reference12",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference12",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"reference13",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference13",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"reference14",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference14",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"reference15",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference15",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"reference16",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference16",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"reference17",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference17",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"reference18",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference18",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"reference19",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference19",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"reference20",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference20",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"reference21",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference21",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:240 },
                {Header:"reference22",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference22",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:240 },
                {Header:"reference23",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference23",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:240 },
                {Header:"reference24",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference24",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:240 },
                {Header:"reference25",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference25",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:240 },
                {Header:"reference26",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference26",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:240 },
                {Header:"reference27",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference27",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:240 },
                {Header:"reference28",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference28",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:240 },
                {Header:"reference29",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference29",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:240 },
                {Header:"reference30",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reference30",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:240 },
                {Header:"jeBatchId",						Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jeBatchId",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"periodName",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"periodName",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
                {Header:"jeHeaderId",						Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jeHeaderId",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"jeLineNum",						Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jeLineNum",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"chartOfAccountsId",				Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chartOfAccountsId",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"functionalCurrencyCode",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"functionalCurrencyCode",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
                {Header:"codeCombinationId",				Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"codeCombinationId",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"dateCreatedInGl",					Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"dateCreatedInGl",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"warningCode",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"warningCode",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
                {Header:"statusDescription",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"statusDescription",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:240 },
                {Header:"statAmount",						Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"statAmount",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"groupId",							Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"groupId",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"requestId",						Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"requestId",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"subledgerDocSequenceId",			Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"subledgerDocSequenceId",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"subledgerDocSequenceValue",		Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"subledgerDocSequenceValue",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"attribute1",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"attribute2",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"glSlLinkId",						Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"glSlLinkId",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"glSlLinkTable",					Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"glSlLinkTable",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
                {Header:"attribute3",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute3",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"attribute4",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute4",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"attribute5",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute5",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"attribute6",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute6",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"attribute7",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute7",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"attribute8",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute8",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"attribute9",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute9",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"attribute10",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute10",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"attribute11",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute11",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"attribute12",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute12",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"attribute13",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute13",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"attribute14",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute14",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"attribute15",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute15",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"attribute16",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute16",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"attribute17",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute17",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"attribute18",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute18",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"attribute19",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute19",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"attribute20",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attribute20",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"context",							Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"context",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"context2",							Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"context2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"invoiceDate",						Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"invoiceDate",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"taxCode",							Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"taxCode",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
                {Header:"invoiceIdentifier",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"invoiceIdentifier",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
                {Header:"invoiceAmount",					Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"invoiceAmount",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"context3",							Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"context3",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:150 },
                {Header:"ussglTransactionCode",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ussglTransactionCode",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
                {Header:"descrFlexErrorMessage",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"descrFlexErrorMessage",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:240 },
                {Header:"jgzzReconRef",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jgzzReconRef",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:240 },
                {Header:"referenceDate",					Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"referenceDate",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"setOfBooksId",						Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"setOfBooksId",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"ledgerId",							Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ledgerId",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
            ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

            $(window).smartresize(sheetResize); sheetInit();
            doAction1("Search");

            $("").bind("keyup",function(event){
                if( event.keyCode == 13){
                    doAction1("Search");
                }
            });

        });

        //Sheet1 Action
        function doAction1(sAction) {
            switch (sAction) {
                case "Search":
                    if(!checkList()) return ;
                    $("#pSearchYm").val($("#searchYm", parent.document).val().replace(/-/g,""));
                    sheet1.RemoveAll();
                    sheet1.DoSearch( "${ctx}/InOutOrgMgr.do?cmd=getInOutOrgMgrTab2List", $("#sendForm").serialize() );
                    break;
                case "Down2Excel":
                    var downcol = makeHiddenSkipCol(sheet1);
                    var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
                    sheet1.Down2Excel(param);

                    break;
                case "Create":

                    var searchYm = $("#searchYm", parent.document).val();
                    if ( searchYm == "" ){
                        alert("결산년월은 필수값입니다.");
                        break;
                    }

                    if ( !confirm("전표생성 하시겠습니까?")){break;}

                    progressBar(true, "전표생성 중입니다.");

                    $.ajax({
                        url : "${ctx}/InOutOrgMgr.do?cmd=inOutOrgMgrPrc2",
                        type : "post",
                        dataType : "json",
                        async : true,
                        data : $("#sendForm").serialize(),
                        success : function(result) {

                            progressBar(false);
                            if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
                                if (result["Result"]["Code"] == "") {
                                    alert("전표생성이 완료되었습니다.");
                                    doAction1("Search");
                                } else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
                                    alert(result["Result"]["Message"]);
                                    doAction1("Search");
                                }
                            } else {
                                alert("전표생성 시 오류가 발생하였습니다.");
                            }
                        },
                        error : function(jqXHR, ajaxSettings, thrownError) {
                            progressBar(false);
                            ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
                        }
                    });

                    break;

                case "Submit":

                    var searchYm = $("#searchYm", parent.document).val();
                    if ( searchYm == "" ){
                        alert("결산년월은 필수값입니다.");
                        break;
                    }
                    var data = ajaxCall("${ctx}/InOutOrgMgr.do?cmd=getInOutOrgMgrITFIDMap","searchYm="+searchYm, false).DATA;
                    if ( data != null ) {

                        var interfaceId = data.interfaceId;

                        // GL전표 자료 생성
                        var glCreRtn = ajaxCall("${ctx}/GLStatementMgr.do?cmd=gLStatementMgrPrc","interfaceId="+interfaceId, false);

                        if(glCreRtn.Result != null) {

                            // 전표 전송
                            var ifId = "IF_SRD_GHR_ERP_0001"; //GL전표(고정)
                            var rtn = ajaxCall("${ctx}/InterfaceEAI.do?cmd=restApiCall","ifId="+ifId, false);
                            if(rtn.Result.ResultMessage == "S") {
                                alert("전송 처리되었습니다.");
                            } else {
                                alert("전송 실패하였습니다.");
                            }
                        }
                    } else {
                        alert("전송처리할 인터페이스ID 조회에 실패하였습니다.");
                    }

                    break;
            }
        }

        // 조회 후 에러 메시지
        function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") {
                    alert(Msg);
                }

                sheetResize();

            } catch (ex) {
                alert("OnSearchEnd Event Error : " + ex);
            }
        }

        // 저장 후 메시지
        function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") {
                    alert(Msg);
                }
                doAction1("Search");
            } catch (ex) {
                alert("OnSaveEnd Event Error " + ex);
            }
        }

        // 입력시 조건 체크
        function checkList(){
            var ch = true;
            var exit = false;
            if(exit){return false;}
            // 화면의 개별 입력 부분 필수값 체크
            $(".required").each(function(index){
                if($(this).val() == null || $(this).val() == ""){
                    alert($(this).parent().prepend().find("span:first-child").text()+"은(는) 필수값입니다.");
                    $(this).focus();
                    ch =  false;
                    return false;
                }
            });
            return ch;
        }

        function getReturnValue(returnValue) {

            var rv = $.parseJSON('{'+ returnValue+'}');

        }
    </script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form name="sendForm" id="sendForm" method="post">
        <input type="hidden" id="pSearchYm" name="pSearchYm" />
    </form>
    <div class="inner">
        <div class="sheet_title">
            <ul>
                <li class="txt">전출입 전표조회</li>
                <li class="btn">
                    <a href="javascript:doAction1('Create');" 			class="basic authA">GL전표생성</a>
                    <a href="javascript:doAction1('Submit');" 			class="basic authA">GL전표전송</a>
                    <a href="javascript:doAction1('Down2Excel');" 		class="basic authR">다운로드</a>
                </li>
            </ul>
        </div>
    </div>

    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
