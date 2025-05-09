<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {

		if("${ssnEnterAllYn}" == "Y"){
			$(".spEnterCombo").removeClass("hide");
		}

        <%-- $("#searchYyyy").val("<%=DateUtil.getThisYear()%>") ;//현재년월 세팅

        $("#searchYyyy").keyup(function() {
            makeNumber(this,'A');
        })
        $("#searchYyyy").bind("keyup",function(event){
            if( event.keyCode == 13){
            	doAction1("Search");
                $(this).focus();
            }
        }); --%>

		// 트리레벨 정의
		$("#btnPlus").click(function() {
			sheet1.ShowTreeLevel(-1);
		});
		$("#btnStep1").click(function()	{
			sheet1.ShowTreeLevel(0, 1);
		});
		$("#btnStep2").click(function()	{
			sheet1.ShowTreeLevel(1,2);
		});
		$("#btnStep3").click(function()	{
			sheet1.ShowTreeLevel(-1);
		});

		$("#searchBaseDate").mask("1111-11-11");
		$("#searchBaseDate").val("${curSysYyyyMMddHyphen}") ;//현재년월 세팅
		$("#searchBaseYmd").val("${curSysYyyyMMddHyphen}") ;//현재년월 세팅
		
		if("${ssnAdminYn}" == "Y") {
			$("#searchBaseDate").datepicker2();
		}else{
			$("#searchBaseDate").datepicker2({startdate:"searchBaseYmd"} );
		}
		
		$("#searchBaseDate").bind("change",function(event){
			if($("#searchBaseDate").val() > $("#searchBaseYmd").val() && $("#searchBaseDate").val().length ==10 && "${ssnAdminYn}" != "Y" ) {
				//alert("오늘 이전 날짜로 입력해주세요.");
				$("#searchBaseDate").val($("#searchBaseYmd").val()); 
				return;
			}
				
		});
		
		

		$("#searchBaseDate").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});
	});

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:12, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata.Cols = [
 			  {Header:"No|No", 				Type:"${sNoTy}",  Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"sNo" },
              {Header:"시작일|시작일", 			Type:"Text",      Hidden:1,  width:10,   Align:"Left",    ColMerge:0,   SaveName:"sdate",         KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
              {Header:"상위조직코드|상위조직코드",	Type:"Text",  	  Hidden:1,  width:10,   Align:"Left",    ColMerge:0,   SaveName:"priorOrgCd",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
              {Header:"조직코드|조직코드", 		Type:"Text",      Hidden:1,  width:10,   Align:"Left",    ColMerge:0,   SaveName:"orgCd",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			  {Header:"조직명|조직명",			Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, Cursor:"",    TreeCol:1,  LevelSaveName:"sLevel" },
              {Header:"조직장|조직장", 			Type:"Text",      Hidden:1,  width:10,   Align:"Center",  ColMerge:0,   SaveName:"orgChief",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },

              {Header:"기준년도\n(1월~기준일)|입사",         Type:"AutoSum",       Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"empCnt1",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"기준년도\n(1월~기준일)|퇴사",         Type:"AutoSum",       Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"empCnt5",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"기준년도\n(1월~기준일)|휴직",         Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"empCnt2",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"기준년도\n(1월~기준일)|복직",         Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"empCnt3",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"기준년도\n(1월~기준일)|이동",         Type:"AutoSum",       Hidden:1,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"empCnt4",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"기준일|현인원", 		Type:"AutoSum",   	  Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"empTotCnt",  KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" ,   BackColor:"#e8a85f"},
              
              {Header:"1월|입사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt11",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"1월|퇴사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt15",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"1월|휴직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt12",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"1월|복직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt13",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"1월|이동",           	Type:"AutoSum",       Hidden:1,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt14",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"1월|월말\n인원",        Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpTotCnt1",  KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },

              {Header:"2월|입사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt21",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"2월|퇴사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt25",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"2월|휴직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt22",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"2월|복직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt23",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"2월|이동",           	Type:"AutoSum",       Hidden:1,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt24",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"2월|월말\n인원",        Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpTotCnt2",  KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },

              {Header:"3월|입사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt31",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"3월|퇴사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt35",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"3월|휴직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt32",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"3월|복직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt33",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"3월|이동",           	Type:"AutoSum",       Hidden:1,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt34",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"3월|월말\n인원",        Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpTotCnt3",  KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },

              {Header:"4월|입사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt41",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"4월|퇴사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt45",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"4월|휴직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt42",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"4월|복직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt43",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"4월|이동",           	Type:"AutoSum",       Hidden:1,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt44",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"4월|월말\n인원",        Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpTotCnt4",  KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },

              {Header:"5월|입사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt51",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"5월|퇴사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt55",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"5월|휴직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt52",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"5월|복직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt53",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"5월|이동",           	Type:"AutoSum",       Hidden:1,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt54",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"5월|월말\n인원",        Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpTotCnt5",  KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },

              {Header:"6월|입사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt61",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"6월|퇴사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt65",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"6월|휴직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt62",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"6월|복직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt63",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"6월|이동",           	Type:"AutoSum",       Hidden:1,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt64",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"6월|월말\n인원",        Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpTotCnt6",  KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },

              {Header:"7월|입사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt71",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"7월|퇴사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt75",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"7월|휴직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt72",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"7월|복직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt73",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"7월|이동",           	Type:"AutoSum",       Hidden:1,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt74",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"7월|월말\n인원",        Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpTotCnt7",  KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },

	          {Header:"8월|입사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt81",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"8월|퇴사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt85",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"8월|휴직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt82",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"8월|복직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt83",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"8월|이동",           	Type:"AutoSum",       Hidden:1,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt84",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"8월|월말\n인원",        Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpTotCnt8",  KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },

	          {Header:"9월|입사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt91",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"9월|퇴사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt95",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"9월|휴직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt92",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"9월|복직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt93",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"9월|이동",           	Type:"AutoSum",       Hidden:1,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt94",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"9월|월말\n인원",        Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpTotCnt9",  KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },

	          {Header:"10월|입사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt101",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"10월|퇴사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt105",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"10월|휴직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt102",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"10월|복직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt103",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"10월|이동",           	Type:"AutoSum",       Hidden:1,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt104",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"10월|월말\n인원",       Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpTotCnt10",  KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },

	          {Header:"11월|입사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt111",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"11월|퇴사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt115",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"11월|휴직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt112",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"11월|복직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt113",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"11월|이동",           	Type:"AutoSum",       Hidden:1,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt114",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"11월|월말\n인원",       Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpTotCnt11",  KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },

	          {Header:"12월|입사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt121",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"12월|퇴사",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt125",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"12월|휴직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt122",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"12월|복직",           	Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt123",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"12월|이동",           	Type:"AutoSum",       Hidden:1,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpCnt124",    KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" },
              {Header:"12월|월말\n인원",       Type:"AutoSum",       Hidden:0,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"monEmpTotCnt12",  KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, Cursor:"Pointer" }

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		// 헤더 머지
		sheet1.SetMergeSheet( msHeaderOnly);

		$(window).smartresize(sheetResize); sheetInit();
		/*
		$("#checkExcept1, #checkExcept2, #checkExcept3").on("click", function(e) {
			doAction1("Search");
		});		
		*/
		// 회사코드
		var enterCdList   = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getGroupEnterCdList", false).codeList, "");
		$("#groupEnterCd").html(enterCdList[2]);
		$("#groupEnterCd").val("${ssnEnterCd}");
		$("#groupEnterCd").on("change", function(event) {
			doAction1("Search");
		}).change();

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			 if($("#searchBaseDate").val() == ""){
				alert("기준일자를 입력하세요");
				return;
			}
			var except = $("#except1").val() + $("#except2").val() + $("#except3").val();
			sheet1.DoSearch( "${ctx}/OrgCapaInfoSta.do?cmd=getOrgCapaInfoStaSheet1List&except="+except, $("#srchFrm").serialize() ); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		}
	}

	// 셀에 마우스 클릭했을때 발생하는 이벤트
  	function sheet1_OnClick(Row, Col, Value){
	  try{
		var searchMonth = "";
		var ordTypeCd = "";  // 발령코드 A:입사, C:휴직, D:복직, H:이동, E:퇴직
		var sumRow = sheet1.FindSumRow();

		if( sheet1.ColSaveName(Col) == "monEmpTotCnt1") searchMonth = "01";
		if( sheet1.ColSaveName(Col) == "monEmpCnt11" 
			|| sheet1.ColSaveName(Col) == "monEmpCnt12" 
			|| sheet1.ColSaveName(Col) == "monEmpCnt13" 
			|| sheet1.ColSaveName(Col) == "monEmpCnt14" 
			|| sheet1.ColSaveName(Col) == "monEmpCnt15" 
			) searchMonth = "01";
		if( sheet1.ColSaveName(Col) == "monEmpTotCnt2") searchMonth = "02";
		if( sheet1.ColSaveName(Col) == "monEmpCnt21" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt22" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt23" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt24" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt25" 
		) searchMonth = "02";
		if( sheet1.ColSaveName(Col) == "monEmpTotCnt3") searchMonth = "03";
		if( sheet1.ColSaveName(Col) == "monEmpCnt31" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt32" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt33" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt34" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt35" 
		) searchMonth = "03";
		if( sheet1.ColSaveName(Col) == "monEmpTotCnt4") searchMonth = "04";
		if( sheet1.ColSaveName(Col) == "monEmpCnt41" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt42" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt43" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt44" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt45" 
		) searchMonth = "04";
		if( sheet1.ColSaveName(Col) == "monEmpTotCnt5") searchMonth = "05";
		if( sheet1.ColSaveName(Col) == "monEmpCnt51" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt52" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt53" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt54" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt55" 
		) searchMonth = "05";
		if( sheet1.ColSaveName(Col) == "monEmpTotCnt6") searchMonth = "06";
		if( sheet1.ColSaveName(Col) == "monEmpCnt61" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt62" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt63" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt64" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt65" 
		) searchMonth = "06";
		if( sheet1.ColSaveName(Col) == "monEmpTotCnt7") searchMonth = "07";
		if( sheet1.ColSaveName(Col) == "monEmpCnt71" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt72" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt73" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt74" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt75" 
		) searchMonth = "07";
		if( sheet1.ColSaveName(Col) == "monEmpTotCnt8") searchMonth = "08";
		if( sheet1.ColSaveName(Col) == "monEmpCnt81" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt82" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt83" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt84" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt85" 
		) searchMonth = "08";
		if( sheet1.ColSaveName(Col) == "monEmpTotCnt9") searchMonth = "09";
		if( sheet1.ColSaveName(Col) == "monEmpCnt91" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt92" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt93" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt94" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt95" 
		) searchMonth = "09";
		if( sheet1.ColSaveName(Col) == "monEmpTotCnt10") searchMonth = "10";
		if( sheet1.ColSaveName(Col) == "monEmpCnt101" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt102" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt103" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt104" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt105" 
		) searchMonth = "10";
		if( sheet1.ColSaveName(Col) == "monEmpTotCnt11") searchMonth = "11";
		if( sheet1.ColSaveName(Col) == "monEmpCnt111" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt112" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt113" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt114" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt115" 
		) searchMonth = "11";
		if( sheet1.ColSaveName(Col) == "monEmpTotCnt12") searchMonth = "12";
		if( sheet1.ColSaveName(Col) == "monEmpCnt121" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt122" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt123" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt124" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt125" 
		) searchMonth = "12";

		// 현인원 
		if( sheet1.ColSaveName(Col) == "empTotCnt" 
		|| sheet1.ColSaveName(Col) == "empCnt1" 
		|| sheet1.ColSaveName(Col) == "empCnt2" 
		|| sheet1.ColSaveName(Col) == "empCnt3" 
		|| sheet1.ColSaveName(Col) == "empCnt4" 
		|| sheet1.ColSaveName(Col) == "empCnt5" 
		) searchMonth = "00";

		
		// 입사
		if(sheet1.ColSaveName(Col) == "empCnt1" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt11" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt21" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt31" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt41" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt51" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt61" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt71" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt81" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt91" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt101" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt111" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt121" ) ordTypeCd = "A";
		
		// 휴직
		if(sheet1.ColSaveName(Col) == "empCnt2" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt12" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt22" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt32" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt42" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt52" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt62" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt72" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt82" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt92" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt102" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt112" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt122" ) ordTypeCd = "C";

		// 복직
		if(sheet1.ColSaveName(Col) == "empCnt3" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt13" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt23" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt33" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt43" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt53" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt63" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt73" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt83" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt93" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt103" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt113" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt123" ) ordTypeCd = "D";

		// 이동
		if(sheet1.ColSaveName(Col) == "empCnt4" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt14" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt24" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt34" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt44" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt54" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt64" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt74" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt84" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt94" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt104" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt114" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt124" ) ordTypeCd = "H";

		// 퇴사
		if(sheet1.ColSaveName(Col) == "empCnt5" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt15" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt25" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt35" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt45" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt55" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt65" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt75" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt85" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt95" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt105" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt115" 
		|| sheet1.ColSaveName(Col) == "monEmpCnt125" ) ordTypeCd = "E";

		if(Col >= 6 && sheet1.GetCellValue(Row, Col) != "" && sumRow  != Row) {
		    if( Row != 2) {
	            if(!isPopup()) {return;}
				gPRow = "";
				pGubun = "orgCapaEmpPopup";
	            const p = {
	            		searchBaseDate: $("#searchBaseDate").val(),
	            		searchOrgNm: sheet1.GetCellValue(Row,"orgNm"),
	            		searchOrgCd: sheet1.GetCellValue(Row,"orgCd"),
	            		searchColNm: sheet1.GetCellText(1, Col),
	            		searchMonth: searchMonth,
	            		searchYear: $("#searchYear").val(),
	            		searchOrdTypeCd: ordTypeCd,
	            		groupEnterCd: $("#groupEnterCd").val()
	    	    };
	            var layer = new window.top.document.LayerModal({
	              		id : 'orgCapaEmpLayer'
	                  , url : '/OrgCapaEmpPopup.do?cmd=viewOrgCapaEmpLayer&authPg=${authPg}'
	                  , parameters: p
	                  , width : 650
	                  , height : 720
	                  , title : "인원조회"
	                  , trigger :[
	                      {
	                            name : 'orgCapaEmpLayerTrigger'
	                          , callback : function(rv){
	                        	  var sabun = rv["sabun"];
	                  			  var enterCd = rv["enterCd"];			
	                  			  goMenu(sabun,enterCd);
	                          }
	                      }
	                  ]
	              });
     		  	layer.show();
	            //openPopup("/OrgCapaEmpPopup.do?cmd=orgCapaEmpPopup&authPg=${authPg}", args, "650","720");
	        }
	    }
	  }catch(ex){alert("OnClick Event Error : " + ex);}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } 
		
		sheet1.ShowTreeLevel(3, 4); sheetResize();  
		
		// 조회년도저장
		$("#searchYear").val($("#searchBaseDate").val().substr(0,4));
		
		}catch (ex) { alert("OnSearchEnd Event Error : " + ex); }

	}
	

	// 셀이 선택되었을때 발생하는 이벤트
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
	    	$("#searchOrgCd").val(sheet1.GetCellValue(NewRow, "orgCd"));
	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	// 비교대상 화면으로 이동
	function goMenu(sabun,enterCd) {
        //비교대상 정보 쿠키에 담아 관리
        var paramObj = [{"key":"searchSabun", "value":sabun},{"key":"searchEnterCd", "value":enterCd}];

        //var prgCd = "View.do?cmd=viewPsnalBasicInf";
        var prgCd = "PsnalBasicInf.do?cmd=viewPsnalBasicInf";
        var location = "인사관리 > 인사정보 > 인사기본";

        var $form = $('<form></form>');
        $form.appendTo('body');
        var param1 	= $('<input name="prgCd" 	type="hidden" 	value="'+prgCd+'">');
        var param2 	= $('<input name="goMenu" 	type="hidden" 	value="Y">');
        $form.append(param1).append(param2);

    	var prgData = ajaxCall("${ctx}/OrgPersonSta.do?cmd=getCompareEmpOpenPrgMap",$form.serialize(),false);

    	if(prgData.map == null) {
			alert("<msg:txt mid='109611' mdef='권한이 없거나 존재하지 않는 메뉴입니다.'/>");
			return;
		}

    	var lvl 		= prgData.map.lvl;
    	var menuId		= prgData.map.menuId;
		var menuNm 		= prgData.map.menuNm;
		var menuNmPath	= prgData.map.menuNmPath;
		var prgCd 		= prgData.map.prgCd;
		var mainMenuNm 	= prgData.map.mainMenuNm;
		var surl      	= prgData.map.surl;
		parent.openContent(menuNm,prgCd,location,surl,menuId,paramObj);
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<form id="srchFrm" name="srchFrm" >
			<input type="hidden" id="searchYear" name="searchYear">
			<input type="hidden" id="searchOrgCd"  name="searchOrgCd"/>
		
			<input type="hidden" id="except1" name="except1"/>
			<input type="hidden" id="except2" name="except2"/>
			<input type="hidden" id="except3" name="except3"/>
			<input type="hidden" id="searchBaseYmd" name="searchBaseYmd"/>	
				
				
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th class="spEnterCombo hide">회사 </th>
						<td class="spEnterCombo hide">
							<select id="groupEnterCd" name="groupEnterCd" class="w150"></select>
						</td>
						<!-- <td class="hide">
							<span>기준년도 </span>
							<input class="text center" type="text" id=searchYyyy name="searchYyyy" size="4" maxlength="4">
						</td> -->
						<th>기준일</th>
						<td >
							<input id="searchBaseDate" name="searchBaseDate" type="text" size="10" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
						</td>
						<!-- 
						<td>
							<span>제외 :
							<input id="checkExcept1" name="checkExcept1" type="checkbox"  class="checkbox" />&nbsp;휴직자
							<input id="checkExcept2" name="checkExcept2" type="checkbox"  class="checkbox" />&nbsp;등기임원
							<input id="checkExcept3" name="checkExcept3" type="checkbox"  class="checkbox" />&nbsp;인턴		
							</span>
							</td>			
						 -->				
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a> </td>
						
					</tr>
				</table>
			</div>
		</div>
	</form>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li id="txt" class="txt">조직별월별인원현황
				<div class="util">
				<ul>
					<li	id="btnPlus"></li>
					<li	id="btnStep1"></li>
					<li	id="btnStep2"></li>
					<li	id="btnStep3"></li>
				</ul>
				</div>
			</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>

</div>
</body>
</html>