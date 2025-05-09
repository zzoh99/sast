<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>퇴직세액 재계산</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<style>
#wkp_cnt_pop { width: 550px; height: 160px; padding: 0.5em; }
</style>
<script>
/*근속연수 입력 관련 div 팝업*/
$(function() {
  $( "#wkp_cnt_pop" ).draggable();
  $( "#wkp_cnt_pop" ).css("display","none");
});

function callback() {
    setTimeout(function() {
      $( "#wkp_cnt_pop" ).removeAttr( "style" ).hide().fadeIn();
    }, 1000 );
  };
  
function hidePopup(){
	//$("#pop1_wkp_ex_m_cnt_2012").val("");
	//$("#pop1_wkp_ex_m_cnt_2013").val("");
	//$("#pop1_wkp_add_m_cnt_2012").val("");
	//$("#pop1_wkp_add_m_cnt_2013").val("");
	//$("#pop2_wkp_ex_m_cnt_2012").val("");
	//$("#pop2_wkp_ex_m_cnt_2013").val("");
	//$("#pop2_wkp_add_m_cnt_2012").val("");
	//$("#pop2_wkp_add_m_cnt_2013").val("");	
	$( "#wkp_cnt_pop" ).hide( "drop");
}

function viewPopup(){
	//$( "#wkp_cnt_pop" ).css("display","block");
	if($("#searchPayActionCd").val() == "") {
		alert("해당인원의 퇴직정보가 없습니다.");
		return;
	}
	var tableX = $( '#wkp_table' ).offset().left + 250;
	var tableY = $( '#wkp_table' ).offset().top;
	$("#wkp_cnt_pop").attr("style","left:"+tableX+"px;position:absolute;top:"+tableY+"px;z-index:1;background:white;border:solid gray;");
	$("#wkp_cnt_pop").css("display","block");
	
	$("#pop1_wkp_ex_m_cnt_2012").val($("#input_j_wkp_ex_m_cnt_2012").val());
	$("#pop1_wkp_ex_m_cnt_2013").val($("#input_j_wkp_ex_m_cnt_2013").val());
	$("#pop1_wkp_add_m_cnt_2012").val($("#input_j_wkp_add_m_cnt_2012").val());
	$("#pop1_wkp_add_m_cnt_2013").val($("#input_j_wkp_add_m_cnt_2013").val());
	$("#pop2_wkp_ex_m_cnt_2012").val($("#input_a_wkp_ex_m_cnt_2012").val());
	$("#pop2_wkp_ex_m_cnt_2013").val($("#input_a_wkp_ex_m_cnt_2013").val());
	$("#pop2_wkp_add_m_cnt_2012").val($("#input_a_wkp_add_m_cnt_2012").val());
	$("#pop2_wkp_add_m_cnt_2013").val($("#input_a_wkp_add_m_cnt_2013").val());
}

function setWkpData(){
	if($("#pop1_wkp_ex_m_cnt_2012").val()==""
	   &&$("#pop1_wkp_ex_m_cnt_2013").val()==""
	   &&$("#pop1_wkp_add_m_cnt_2012").val()==""
	   &&$("#pop1_wkp_add_m_cnt_2013").val()==""
	   &&$("#pop2_wkp_ex_m_cnt_2012").val()==""
	   &&$("#pop2_wkp_ex_m_cnt_2013").val()==""
	   &&$("#pop2_wkp_add_m_cnt_2012").val()==""
	   &&$("#pop2_wkp_add_m_cnt_2013").val()==""){
		$( "#wkp_cnt_pop" ).hide( "drop");
		return;
	}
	   
	var calc1 = parseInt(nvl($("#pop1_wkp_ex_m_cnt_2012").val(),"0").replace(/,/gi,""),10);
	var calc2 = parseInt(nvl($("#pop1_wkp_ex_m_cnt_2013").val(),"0").replace(/,/gi,""),10);
	var calc3 = parseInt(nvl($("#pop1_wkp_add_m_cnt_2012").val(),"0").replace(/,/gi,""),10);
	var calc4 = parseInt(nvl($("#pop1_wkp_add_m_cnt_2013").val(),"0").replace(/,/gi,""),10);
	var calc5 = parseInt(nvl($("#pop2_wkp_ex_m_cnt_2012").val(),"0").replace(/,/gi,""),10);
	var calc6 = parseInt(nvl($("#pop2_wkp_ex_m_cnt_2013").val(),"0").replace(/,/gi,""),10);
	var calc7 = parseInt(nvl($("#pop2_wkp_add_m_cnt_2012").val(),"0").replace(/,/gi,""),10);
	var calc8 = parseInt(nvl($("#pop2_wkp_add_m_cnt_2013").val(),"0").replace(/,/gi,""),10);
	
	//제외월수 가산월수에 계산하여 입력
	$("#input_a_wkp_ex_m_cnt_2012").val(calc5);
	$("#input_a_wkp_ex_m_cnt_2013").val(calc6);
	$("#input_a_wkp_add_m_cnt_2012").val(calc7);
	$("#input_a_wkp_add_m_cnt_2013").val(calc8);
	
	$("#input_j_wkp_ex_m_cnt_2012").val(calc1);
	$("#input_j_wkp_ex_m_cnt_2013").val(calc2);
	$("#input_j_wkp_add_m_cnt_2012").val(calc3);
	$("#input_j_wkp_add_m_cnt_2013").val(calc4);
	
	//제외월수 가산월수에 계산하여 입력
	$("#input_j_wkp_ex_m_cnt").val(calc1+calc2);
	$("#input_j_wkp_add_m_cnt").val(calc3+calc4);
	$("#input_a_wkp_ex_m_cnt").val(calc5+calc6);
	$("#input_a_wkp_add_m_cnt").val(calc7+calc8);
	setSheetData();
	$( "#wkp_cnt_pop" ).hide( "drop");
}

</script>
  
<script type="text/javascript">

	$(function(){
		$("#searchSabun").val( $("#searchUserId").val() ) ;
		
		//퇴직사유 셀렉트박스
		var retReason= stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00440"), "");
		
		var retReasonTxt = "<option value=''></option>"+retReason[2];
		$("#select_a_ret_reason").html(retReasonTxt);

		$("#input_a_db_gaib_ymd").datepicker2();
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		//a_:771(퇴직금실적),h_:772(퇴직소득세액계산),j_:768(중간지급등현황),k_:777(퇴직소득과세이연 기초데이터)
		<%int colIdx = 0;%>
		initdata1.Cols = [
 			{Header:"No",		Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
   			{Header:"삭제",		Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},    
   			{Header:"상태",		Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},    
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pay_action_cd",  			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",  					KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_enter_nm",  			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_regino_num",  			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_imwon_yn",  			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_emp_ymd",  				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_sep_symd",  			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_sep_eymd",  			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_ret_ymd",  				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_payment_ymd",  			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_last_wkp_m_cnt",  			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_wkp_ex_m_cnt",  		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_wkp_add_m_cnt",  		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_last_wkp_y_cnt",  			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_jungsan_twkp_y_cnt",  			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_notax_mon",  			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_ret_mon",  				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_declare_itax_mon",  	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_declare_rtax_mon",  	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_declare_stax_mon",  	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_t_declare_mon_tot",  	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_t_itax_mon",  			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_t_rtax_mon",  			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_t_stax_mon",  			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_t_tax_tot",  			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_ret_mon_20111231",  	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_regi_nm",  				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_regi_no",  				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_notax_mon",  			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_ret_mon",  				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_paid_tax_mon",  		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_emp_ymd",  				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_sep_symd",  			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_ret_ymd",  				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_payment_ymd",  			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_wkp_m_cnt",  			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_wkp_ex_m_cnt",  		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_wkp_add_m_cnt",  		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_wkp_dup_m_cnt",  		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_wkp_y_cnt",  			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_emp_2012",  		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_symd_2012",  		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_ret_2012",  		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_payment_2012",  	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_m_cnt_2012",  		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_ex_m_cnt_2012",  	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_add_m_cnt_2012",  	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_dup_m_cnt_2012",  	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_y_cnt_2012",  		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_sep_symd_junsan",  		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_jungsan_twkp_m_cnt",  	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_wkp_dup_m_cnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_ex_m_cnt_junsan", 	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_add_m_cnt_junsan",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_emp_2013",  		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_symd_2013",  		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_ret_2013",  		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_payment_2013",  	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_m_cnt_2013",  		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_ex_m_cnt_2013",  	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_add_m_cnt_2013",  	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_dup_m_cnt_2013",  	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"h_wkp_y_cnt_2013",  		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"k_bank_nm",  				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"k_bank_enter_no",  		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"k_bank_account",  		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"k_defer_ymd",  			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"k_cur_defer_mon",  		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"k_cal_defer_tax_mon",  	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"k_div_cal_defer_tax_mon", KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"k_cal_defer_tax_mon_tot", KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_ytax_mon", 				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_ytax_mon", 				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"hap_ret_mon", 			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"hap_notax_mon", 			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"hap_ytax_mon", 			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"hap_paid_tax_mon", 		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_ret_reason", 			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_db_gaib_ymd", 			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_wkp_ex_m_cnt_2012", 	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_wkp_ex_m_cnt_2013", 	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_wkp_add_m_cnt_2012", 	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a_wkp_add_m_cnt_2013", 	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_wkp_ex_m_cnt_2012", 	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_wkp_ex_m_cnt_2013", 	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_wkp_add_m_cnt_2012", 	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<%=colIdx++%>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_wkp_add_m_cnt_2013", 	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 }
		
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		sheetInit();
		
		getPayAction();
	});
	
	$(function(){
		$("#input_j_emp_ymd").datepicker2({showtarget:false});
		$("#input_j_sep_symd").datepicker2({showtarget:false});
		$("#input_j_ret_ymd").datepicker2({showtarget:false});
		$("#input_j_payment_ymd").datepicker2({showtarget:false});
		$("#input_k_defer_ymd").datepicker2({showtarget:false});
		
		$('#input_a_ret_mon_20111231').mask('000,000,000,000,000', {reverse: true});
		$('#input_j_notax_mon').mask('000,000,000,000,000',{reverse: true});
		$('#input_a_notax_mon').mask('000,000,000,000,000', {reverse: true});
		$('#input_j_ret_mon').mask('000,000,000,000,000', {reverse: true});
		//$('#a_ret_mon').mask('000,000,000,000,000', {reverse: true});
		$('#input_j_paid_tax_mon').mask('000,000,000,000,000', {reverse: true});
		$('#input_k_cur_defer_mon').mask('000,000,000,000,000', {reverse: true});

		$('#input_j_wkp_m_cnt').mask('0000', {reverse: true});
		$('#input_j_wkp_ex_m_cnt').mask('0000', {reverse: true});
		$('#input_j_wkp_add_m_cnt').mask('0000', {reverse: true});
		$('#input_j_wkp_y_cnt').mask('0000', {reverse: true});
		
		$('#input_j_notax_mon,#input_a_notax_mon,#input_j_ret_mon,#input_j_paid_tax_mon').keyup(function(){setSumText()});
	});
	
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":  
			sheet1.DoSearch( "<%=jspPath%>/retTaxReCre/retTaxReCreRst.jsp?cmd=selectRetTaxReCreList", $("#srchFrm").serialize() ); 
       	break;
		case "Save":
			var save777 = "N";
			if(!setSheetData()) {
				return;
			}
			
			if(sheet1.GetCellValue(1,"k_bank_nm") != sheet1.CellSearchValue(1, "k_bank_nm")
					|| sheet1.GetCellValue(1,"k_defer_ymd") != sheet1.CellSearchValue(1, "k_defer_ymd")
					|| sheet1.GetCellValue(1,"k_bank_enter_no") != sheet1.CellSearchValue(1, "k_bank_enter_no")
					|| sheet1.GetCellValue(1,"k_bank_account") != sheet1.CellSearchValue(1, "k_bank_account")
					|| sheet1.GetCellValue(1,"k_cur_defer_mon") != sheet1.CellSearchValue(1, "k_cur_defer_mon")) {
				
				if(sheet1.GetCellValue(1,"k_bank_account") == "") {
					alert("계좌번호를 입력하여 주십시오.");
					return;
				}
				
				if(sheet1.GetCellValue(1,"k_defer_ymd") == "") {
					alert("입금일을 입력하여 주십시오.");
					return;
				}
				save777 = "Y";
			}

			sheet1.DoSave( "<%=jspPath%>/retTaxReCre/retTaxReCreRst.jsp?cmd=saveRetTaxReCre&save777="+save777, $("#srchFrm").serialize()); 
       	break;
		}
	}
	
	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			setFormData();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				doAction1("Search");
			}
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	//폼으로 입력
	function setFormData() {
		if(sheet1.RowCount() > 0) {
			$("#contents table td input[type=text]").each(function(){
				$(this).val(sheet1.GetCellText(1,$(this).attr("id").replace("input_","")));
			});

			$("#contents table td select[id^='select_']").each(function(){
				$(this).val(sheet1.GetCellText(1,$(this).attr("id").replace("select_","")));
			});
			
			$("input[id='input_a_imwon_yn'][value='"+sheet1.GetCellValue(1,"a_imwon_yn")+"']").attr("checked",true);
		} else {
			$("#contents table td input[type=text]").val("");
			$("#contents table td select").val("");
			$("input[id='input_a_imwon_yn']").attr("checked",false);
		}
	}
	
	//쉬트로 입력.
	function setSheetData() {
		if($("#searchPayActionCd").val() == "" || sheet1.RowCount() == 0) {
			alert("해당인원의 퇴직정보가 없습니다.");
			return false;
		} else {
			$("#contents table td input[type=text][id^='input_']").each(function(){
				sheet1.SetCellValue(1,$(this).attr("id").replace("input_",""),$(this).val());
			});
			
			$("#contents table td select[id^='select_']").each(function(){
				sheet1.SetCellValue(1,$(this).attr("id").replace("select_",""),$(this).val());
			});
			
			sheet1.SetCellValue(1,"a_imwon_yn",$("input[id='input_a_imwon_yn']:checked").val());
			//sheet1.SetCellValue(1,"a_imwon_yn",$("input[id='select_a_imwon_yn']:checked").val());
		}
		return true;
	}
	
	//합계 계산
	function setSumText() {
		var jYtaxMon = parseInt(nvl($("#input_j_notax_mon").val(),"0").replace(/,/gi,""),10)+parseInt(nvl($("#input_j_ret_mon").val(),"0").replace(/,/gi,""),10);
		var aYtaxMon = parseInt(nvl($("#input_a_notax_mon").val(),"0").replace(/,/gi,""),10)+parseInt(nvl($("#a_ret_mon").val(),"0").replace(/,/gi,""),10);
		var hapNotaxMon = parseInt(nvl($("#input_a_notax_mon").val(),"0").replace(/,/gi,""),10)+parseInt(nvl($("#input_j_notax_mon").val(),"0").replace(/,/gi,""),10);
		var hapRetMon = parseInt(nvl($("#a_ret_mon").val(),"0").replace(/,/gi,""),10)+parseInt(nvl($("#input_j_ret_mon").val(),"0").replace(/,/gi,""),10);
		
		$("#j_ytax_mon").val(getCommaText(jYtaxMon));
		$("#a_ytax_mon").val(getCommaText(aYtaxMon));
		$("#hap_ytax_mon").val(getCommaText(jYtaxMon+aYtaxMon));
		$("#hap_notax_mon").val(getCommaText(hapNotaxMon));
		$("#hap_ret_mon").val(getCommaText(hapRetMon));
		$("#hap_paid_tax_mon").val($("#input_j_paid_tax_mon").val());
	}
	
	//성명 바뀌면 호출
	function setEmpPage() {
		$("#searchSabun").val( $("#searchUserId").val() ) ;
		$("#searchRegNo").val( $("#searchRegNo_").val() ) ;
		getPayAction();
	}	
	
	//퇴직일자 조회
	function getPayAction(){
		var result = stfConvCode( codeList("<%=jspPath%>/retTaxReCre/retTaxReCreRst.jsp?cmd=selectRetTaxReCreCodeList&searchSabun="+$("#searchSabun").val(),""), "선택하세요");
		
		$("#searchPayActionCd").html( result[2] ) ;
		
		if($("#searchPayActionCd").find("option").length > 1) {
			$("#searchPayActionCd").find("option:eq(1)").attr("selected",true);
		}
		doAction1("Search");
	}
	
	//콤마찍기.
	function getCommaText(val) { 
		var strValue = new String(val);
		
		strValue = strValue.replace(/\D/g,"");

		if (strValue.substr(0,1)==0 ) {
			strValue = strValue.substr(1);
		}

		var l = strValue.length-3;
		while(l>0) {
			strValue = strValue.substr(0,l)+","+strValue.substr(l);
			l -= 3;
		}
		
		return strValue;
	}
	
	//퇴직금재계산
	function taxReCre() {
		
		if(!setSheetData()) {
			return;
		}
		
		if( sheet1.RowCount("I") > 0
				|| sheet1.RowCount("U") > 0 
				|| sheet1.RowCount("D") > 0 ) {
			alert("수정한 내역이 있습니다. 저장후 수행하세요.");
			return;
		}
		
		if(confirm("퇴직세액 재계산을 진행하시겠습니까?")) {
			var data = ajaxCall("<%=jspPath%>/retTaxReCre/retTaxReCreRst.jsp?cmd=prcRetTaxReCre",$("#srchFrm").serialize(),true
				,function(){
					$("#progressCover").show();
				}
				,function(){
					$("#progressCover").hide();
					doAction1("Search");
				}
			);
		}		
	}

	//퇴직소득원천징수영수증 출력
	function print(){
		
		if(!setSheetData()) {
			return;
		}
		
		if( sheet1.RowCount("I") > 0
				|| sheet1.RowCount("U") > 0 
				|| sheet1.RowCount("D") > 0 ) {
			alert("수정한 내역이 있습니다. 저장후 수행하세요.");
			return;
		}
		
		var w 		= 800;
		var h 		= 600;
		var url 	= "<%=jspPath%>/common/rdPopup.jsp";
		var args 	= new Array();
		
		// args의 Y/N 구분자는 없으면 N과 같음
		var rdFileNm = "";
		var year = $("#searchPayActionCd").val().substr(0,4);
		
		if(year*1 > 2007) {
			rdFileNm = "RetireIncomeWithholdReceipt1_"+year+".mrd";
		} else {
			rdFileNm = "RetireIncomeWithholdReceipt1.mrd";
		}
		
		var imgPath = "<%=rdStempImgUrl%>";
		var imgFile = "<%=rdStempImgFile%>";
		
		args["rdTitle"] = "퇴직소득원천징수영수증";//rd Popup제목
		args["rdMrd"] = "<%=cpnYearEndPath%>/"+ rdFileNm; //( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = "[<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>] ['"+$("#searchPayActionCd").val()+"'] ['"+$("#searchSabun").val()+"'] [00000] [A] ["+imgPath+"]" +
						  "[%] [R01] [<%=curSysYyyyMMddHyphen%>] ['"+$("#searchSabun").val()+"'] ['1'] ["+imgFile+"]";//rd파라매터
						  
		//SORTING 파라메터 추가 - 2020.01.02
		if(year*1 >= 2019) {
			args["rdParam"] += "['1']"; //13번째 파라메터
		}

		args["rdParamGubun"] = "rp";//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y";//툴바여부
		args["rdZoomRatio"] = "100";//확대축소비율
		
		args["rdSaveYn"] 	= "Y";//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y";//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "Y";//기능컨트롤_엑셀
		args["rdWordYn"] 	= "Y";//기능컨트롤_워드
		args["rdPptYn"] 	= "Y";//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "Y";//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y";//기능컨트롤_PDF

		if(!isPopup()) {return;}
		var rv = openPopup(url,args,w,h);//알디출력을 위한 팝업창
		//if(rv!=null){
			//return code is empty
		//}
	}	
</script>
</head>
<body class="bodywrap">
<div id="wkp_cnt_pop" class="ui-widget-content" style="display:none">

    <div class="sheet_title">
        <ul>
            <li class="txt">■ 근속제외/가산연수
            </li>
            <li class="btn">
              	<a href="javascript:setWkpData();" class="basic">확인</a>
	  			<a href="javascript:hidePopup();" class="basic">닫기</a>
    		</li>
        </ul>
    </div>
      
  <table class="table inner">
    <colgroup>
        <col width="16%" />
        <col width="21%" />
        <col width="21%" />
        <col width="21%" />
        <col width="21%" />
	</colgroup>  
  	<tr>
  		<th class="center" rowspan="2">근무처<br>구분</th>
  		<th class="center" colspan="2">제외월수</th>
  		<th class="center" colspan="2">가산월수</th>
  	</tr>
	<tr>
  		<th class="center">2012.12.31 이전</th>
  		<th class="center">2013.1.1 이후</th>
  		<th class="center">2012.12.31 이전</th>
  		<th class="center">2013.1.1 이후</th>
  	</tr>
  	<tr>
		<th class="center">중간지급</th>
		<td><input id="pop1_wkp_ex_m_cnt_2012" name="pop1_wkp_ex_m_cnt_2012" type="text" class="text w100p center"/></td>
		<td><input id="pop1_wkp_ex_m_cnt_2013" name="pop1_wkp_ex_m_cnt_2013" type="text" class="text w100p center"/></td>
		<td><input id="pop1_wkp_add_m_cnt_2012" name="pop1_wkp_add_m_cnt_2012" type="text" class="text w100p center"/></td>
		<td><input id="pop1_wkp_add_m_cnt_2013" name="pop1_wkp_add_m_cnt_2013" type="text" class="text w100p center"/></td>
	</tr>
	<tr>
		<th class="center">최종</th>
		<td><input id="pop2_wkp_ex_m_cnt_2012" name="pop2_wkp_ex_m_cnt_2012" type="text" class="text w100p center"/></td>
		<td><input id="pop2_wkp_ex_m_cnt_2013" name="pop2_wkp_ex_m_cnt_2013" type="text" class="text w100p center"/></td>
		<td><input id="pop2_wkp_add_m_cnt_2012" name="pop2_wkp_add_m_cnt_2012" type="text" class="text w100p center"/></td>
		<td><input id="pop2_wkp_add_m_cnt_2013" name="pop2_wkp_add_m_cnt_2013" type="text" class="text w100p center"/></td>
	</tr>  	
  </table>
</div>

<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%; z-index:99;"></div>
<div class="wrapper" style="overflow-y: auto; overflow-x: auto;">
	<%@ include file="../common/include/employeeHeaderYtax.jsp"%>
	<div class="sheet_search outer">
		<form id="srchFrm" name="srchFrm">
        <div>
        <table width="100%">
        <tr>
            <td><span>퇴직일자</span>
				<select id="searchPayActionCd" name="searchPayActionCd" onChange="doAction1('Search')"> </select>
				<input type="hidden" id="searchSabun" name="searchSabun"/>
				<a href="javascript:taxReCre();" class="basic right authA">퇴직세액 재계산</a>
            </td>
            <td class="right">
				<a href="javascript:doAction1('Search');" class="basic">조회</a>
				<a href="javascript:doAction1('Save');" class="basic authA">저장</a>
				<a href="javascript:print();" class="basic authA">출력</a>
            </td>
        </tr>
        </table>
        </div>
		</form>		
    </div>	
	
	<div class="outer" >
	<!-- table1 -->
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
    <div id="contents">
    <table border="0" cellpadding="0" cellspacing="0" class="table inner">
	<colgroup>
        <col width="10%" />
        <col width="12%" />
        <col width="15%" />
        <col width="15%" />
        <col width="10%" />
        <col width="8%" />
        <col width="15%" />
        <col width="15%" />
	</colgroup>
	<tr>
		<th class="center">퇴직사유</th>
		<td class="center"> 
			<select id="select_a_ret_reason" name ="ret_reason" class="box"></select> 
		</td>
		<th class="center">DB형 퇴직연금 가입일</th>
		<td class="center"> 
			<input id="input_a_db_gaib_ymd" name="db_gaib_ymd" type="text" class="text w60p center" /> 
		</td>
		<th class="center">임원여부</th>
		<td class="center"> 
			<INPUT type="radio" name="input_a_imwon_yn" id="input_a_imwon_yn" value = "Y" class="radio" >여&nbsp;
            <INPUT type="radio" name="input_a_imwon_yn" id="input_a_imwon_yn" value = "N" class="radio" >부
		</td>
		<th class="center">2011.12.31 퇴직금</th>
		<td class="center"> 
			<input id="input_a_ret_mon_20111231" name="input_a_ret_mon_20111231" type="text" class="text w100p right" /> 
		</td>
	</tr>
	</table>
	<!-- table2 -->
	<div class="outer">
    <div class="sheet_title">
        <ul>
            <li class="txt">[퇴직급여현황]
            </li>
            <li class="btn">
    		</li>
        </ul>
    </div>
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="table inner">
	<colgroup>
        <col width="25%" />
        <col width="25%" />
        <col width="25%" />
        <col width="25%" />
	</colgroup>
	<tr>
		<th class="center">근무처구분</th>
		<th class="center">중간지급 등</th>
		<th class="center">최종</th>
		<th class="center">정산</th>
	</tr>
	<tr>
		<th >근무처명</th>
		<td class="center"> 
			<input id="input_j_regi_nm" name="input_j_regi_nm" type="text" maxlength="30" class="text w100p center" /> 
		</td>
		<td class="center"> 
			<input id="a_enter_nm" name="a_enter_nm" type="text" class="text w100p center transparent" readOnly /> 
		</td>
		<td class="center" style="background:#ebeef0;"> 
		</td>
	</tr>
		<tr>
		<th >사업자등록번호</th>
		<td class="center"> 
			<input id="input_j_regi_no" name="input_j_regi_no" type="text" maxlength="30" class="text w100p center" /> 
		</td>
		<td class="center"> 
			<input id="a_regino_num" name="a_regino_num" type="text" class="text w100p center transparent" readOnly /> 
		</td>
		<td class="center" style="background:#ebeef0;"> 
		</td>
	</tr>
	<tr>
		<th >퇴직급여</th>
		<td class="center"> 
			<input id="j_ytax_mon" name="j_ytax_mon" type="text" class="text w100p right transparent" readOnly /> 
		</td>
		<td class="center"> 
			<input id="a_ytax_mon" name="a_ytax_mon" type="text" class="text w100p right transparent" readOnly /> 
		</td>
		<td class="center"> 
			<input id="hap_ytax_mon" name="hap_ytax_mon" type="text" class="text w100p right transparent" readOnly /> 
		</td>
	</tr>
	<tr>
		<th >비과세퇴직급여</th>
		<td class="center"> 
			<input id="input_j_notax_mon" name="input_j_notax_mon" type="text" class="text w100p right" /> 
		</td>
		<td class="center"> 
			<input id="input_a_notax_mon" name="input_a_notax_mon" type="text" class="text w100p right" /> 
		</td>
		<td class="center"> 
			<input id="hap_notax_mon" name="hap_notax_mon" type="text" class="text w100p right transparent" readOnly /> 
		</td>
	</tr>
	<tr>
		<th >과세대상퇴직급여</th>
		<td class="center"> 
			<input id="input_j_ret_mon" name="input_j_ret_mon" type="text" class="text w100p right" /> 
		</td>
		<td class="center"> 
			<input id="a_ret_mon" name="a_ret_mon" type="text" class="text w100p right transparent" readOnly/> 
		</td>
		<td class="center"> 
			<input id="hap_ret_mon" name="hap_ret_mon" type="text" class="text w100p right transparent" readOnly/> 
		</td>
	</tr>
	<tr>
		<th >기납부(또는 기 과세이연)세액</th>
		<td class="center"> 
			<input id="input_j_paid_tax_mon" name="input_j_paid_tax_mon" type="text" class="text w100p right" /> 
		</td>
		<td class="center" style="background:#ebeef0;"> 
		</td>
		<td class="center"> 
			<input id="hap_paid_tax_mon" name="hap_paid_tax_mon" type="text" class="text w100p right transparent" readOnly /> 
		</td>
	</tr>
	</table>
	<!-- table3 -->
	<div class="outer">
    <div class="sheet_title">
        <ul>
            <li class="txt">[근속연수]
            <font color='red'> ☜ 반드시 퇴직소득세의 제외월수와 가산월수는 확인 후 직접 입력하여 주십시오.</font>
            </li>
            <li class="btn">
    		</li>
        </ul>
    </div>
    </div>
    <table id="wkp_table" name="wkp_table" border="0" cellpadding="0" cellspacing="0" class="table inner">
	<colgroup>
        <col width="5%" />
		<col width="13%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="8%" />
		<col width="8%" />
		<col width="8%" />
		<col width="8%" />
		<col width="8%" />
	</colgroup>
	<tr>
		<th class="center" colspan="2">구분</th>
		<th class="center">입사일</th>
		<th class="center">기산일</th>
		<th class="center">퇴사일</th>
		<th class="center">지급일</th>
		<th class="center">근속월수</th>
		<th class="center">제외월수</th>
		<th class="center">가산월수</th>
		<th class="center">중복월수</th>
		<th class="center">근속연수</th>
	</tr>
	<tr style="display:none">
		<td><input id="input_j_wkp_ex_m_cnt_2012" name="input_j_wkp_ex_m_cnt_2012" type="text" class="text w100p center" /></td>
		<td><input id="input_j_wkp_ex_m_cnt_2013" name="input_j_wkp_ex_m_cnt_2013" type="text" class="text w100p center" /></td>
		<td><input id="input_j_wkp_add_m_cnt_2012" name="input_j_wkp_add_m_cnt_2012" type="text" class="text w100p center" /></td>
		<td><input id="input_j_wkp_add_m_cnt_2013" name="input_j_wkp_add_m_cnt_2013" type="text" class="text w100p center" /></td>
		<td><input id="input_a_wkp_ex_m_cnt_2012" name="input_a_wkp_ex_m_cnt_2012" type="text" class="text w100p center" /></td>
		<td><input id="input_a_wkp_ex_m_cnt_2013" name="input_a_wkp_ex_m_cnt_2013" type="text" class="text w100p center" /></td>
		<td><input id="input_a_wkp_add_m_cnt_2012" name="input_a_wkp_add_m_cnt_2012" type="text" class="text w100p center" /></td>
		<td><input id="input_a_wkp_add_m_cnt_2013" name="input_a_wkp_add_m_cnt_2013" type="text" class="text w100p center" /></td>
		<td></td>
		<td></td>
		<td></td>
	</tr>
	<tr>
		<th colspan="2">중간지급 근속연수</th>
		<td class="center"> <input id="input_j_emp_ymd" name="input_j_emp_ymd" type="text" class="text w100p center" /> </td>
		<td class="center"> <input id="input_j_sep_symd" name="input_j_sep_ymd" type="text" class="text w100p center" /> </td>
		<td class="center"> <input id="input_j_ret_ymd" name="input_j_ret_ymd" type="text" class="text w100p center" /> </td>
		<td class="center"> <input id="input_j_payment_ymd" name="input_j_payment_ymd" type="text" class="text w100p center" /> </td>
		<td class="center"> <input id="input_j_wkp_m_cnt" name="input_j_wkp_m_cnt" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"> <input id="input_j_wkp_ex_m_cnt" name="input_j_wkp_ex_m_cnt" type="text" class="text w100p right" style="cursor:pointer" onclick="viewPopup();" readonly/> </td>
		<td class="center"> <input id="input_j_wkp_add_m_cnt" name="input_j_wkp_add_m_cnt" type="text" class="text w100p right" style="cursor:pointer" onclick="viewPopup();" readonly/> </td>
		<td class="center" style="background:#ebeef0;"> </td>
		<td class="center"> <input id="input_j_wkp_y_cnt" name="input_j_wkp_y_cnt" type="text" class="text w100p right transparent" readonly/> </td>
	</tr>
	<tr>
		<th colspan="2">최종 근속연수</th>
		<td class="center"> <input id="input_a_emp_ymd" name="input_a_emp_ymd" type="text" class="text w100p center"/> </td>
		<td class="center"> <input id="input_a_sep_symd" name="input_a_sep_symd" type="text" class="text w100p center"/> </td>
		<td class="center"> <input id="input_a_sep_eymd" name="input_a_sep_eymd" type="text" class="text w100p center"/> </td>
		<td class="center"> <input id="input_a_payment_ymd" name="input_a_payment_ymd" type="text" class="text w100p center"/> </td>
		<td class="center"> <input id="a_last_wkp_m_cnt" name="a_last_wkp_m_cnt" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"> <input id="input_a_wkp_ex_m_cnt" name="input_a_wkp_ex_m_cnt" type="text" class="text w100p right" style="cursor:pointer" onclick="viewPopup();" readonly/> </td>
		<td class="center"> <input id="input_a_wkp_add_m_cnt" name="input_a_wkp_add_m_cnt" type="text" class="text w100p right" style="cursor:pointer" onclick="viewPopup();" readonly/> </td>
		<td class="center" style="background:#ebeef0;"> </td>
		<td class="center"> <input id="a_last_wkp_y_cnt" name="a_last_wkp_y_cnt" type="text" class="text w100p right transparent" readonly/> </td>
	</tr>
	<tr>
		<th colspan="2">정산(합산) 근속연수</th>
		<td class="center" style="background:#ebeef0;"> </td>
		<td class="center"> <input id="h_sep_symd_junsan" name="h_sep_symd_junsan" type="text" class="text w100p center transparent" readonly/> </td>
		<td class="center"> <input id="a_sep_eymd" name="a_sep_eymd" type="text" class="text w100p center transparent" readonly/> </td>
		<td class="center" style="background:#ebeef0;"> </td>
		<td class="center"> <input id="a_jungsan_twkp_m_cnt" name="a_jungsan_twkp_m_cnt" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"> <input id="h_wkp_ex_m_cnt_junsan" name="h_wkp_ex_m_cnt_junsan" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"> <input id="h_wkp_add_m_cnt_junsan" name="h_wkp_add_m_cnt_junsan" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"> <input id="a_wkp_dup_m_cnt" name="a_wkp_dup_m_cnt" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"> <input id="a_jungsan_twkp_y_cnt" name="a_jungsan_twkp_y_cnt" type="text" class="text w100p right transparent" readonly/> </td>
	</tr>
	<tr>
		<th rowspan="2">안분</th>
		<th>2012.12.31 이전</th>
		<td class="center" style="background:#ebeef0;"> </td>
		<td class="center"> <input id="h_wkp_symd_2012" name="h_wkp_symd_2012" type="text" class="text w100p center transparent" readonly/> </td>
		<td class="center"> <input id="h_wkp_ret_2012" name="h_wkp_ret_2012" type="text" class="text w100p center transparent" readonly/> </td>
		<td class="center" style="background:#ebeef0;"> </td>
		<td class="center"> <input id="h_wkp_m_cnt_2012" name="h_wkp_m_cnt_2012" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"> <input id="h_wkp_ex_m_cnt_2012" name="h_wkp_ex_m_cnt_2012" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"> <input id="h_wkp_add_m_cnt_2012" name="h_wkp_add_m_cnt_2012" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center" style="background:#ebeef0;"> </td>
		<td class="center"> <input id="h_wkp_y_cnt_2012" name="h_wkp_y_cnt_2012" type="text" class="text w100p right transparent" readonly/> </td>
	</tr>
	<tr>
		
		<th>2013.01.01 이후</th>
		<td class="center" style="background:#ebeef0;"> </td>
		<td class="center"> <input id="h_wkp_symd_2013" name="h_wkp_symd_2013" type="text" class="text w100p center transparent" readonly/> </td>
		<td class="center"> <input id="h_wkp_ret_2013" name="h_wkp_ret_2013" type="text" class="text w100p center transparent" readonly/> </td>
		<td class="center" style="background:#ebeef0;"> </td>
		<td class="center"> <input id="h_wkp_m_cnt_2013" name="h_wkp_m_cnt_2013" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"> <input id="h_wkp_ex_m_cnt_2013" name="h_wkp_ex_m_cnt_2013" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"> <input id="h_wkp_add_m_cnt_2013" name="h_wkp_add_m_cnt_2013" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center" style="background:#ebeef0;"> </td>
		<td class="center"> <input id="h_wkp_y_cnt_2013" name="h_wkp_y_cnt_2013" type="text" class="text w100p right transparent" readonly/> </td>
	</tr>
	</table>
	<!-- table4 -->
	<div class="outer">
    <div class="sheet_title">
        <ul>
            <li class="txt">[이연퇴직소득세액 계산]
            </li>
            <li class="btn">
    		</li>
        </ul>
    </div>
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="table inner">
	<colgroup>
        <col width="10%" />
        <col width="10%" />
        <col width="10%" />
        <col width="10%" />
        <col width="10%" />
        <col width="10%" />
        <col width="10%" />
        <col width="10%" />
	</colgroup>
	<tr>
		<th class="center" rowspan="2">신고대상세액</th>
		<th class="center" colspan="5">연금계좌 입금내역</th>
		<th class="center" rowspan="2">퇴직급여</th>
		<th class="center" rowspan="2">이연퇴직소득세</th>
	</tr>
	<tr>
		<th class="center" >연금계좌취급자</th>
		<th class="center" >사업자등록번호</th>
		<th class="center" >계좌번호</th>
		<th class="center" >입금일</th>
		<th class="center" >계좌입금금액</th>
	</tr>
	<tr>
		<td class="center"> <input id="a_declare_itax_mon" name="a_declare_itax_mon" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"> <input id="input_k_bank_nm" name="input_k_bank_nm" type="text" maxlength="30" class="text w100p center" /> </td>
		<td class="center"> <input id="input_k_bank_enter_no" name="input_k_bank_enter_no" type="text" maxlength="30" class="text w100p center" /> </td>
		<td class="center"> <input id="input_k_bank_account" name="input_k_bank_account" type="text" maxlength="30" class="text w100p center" /> </td>
		<td class="center"> <input id="input_k_defer_ymd" name="input_k_defer_ymd" type="text" class="text w100p center" /> </td>
		<td class="center"> <input id="input_k_cur_defer_mon" name="input_k_cur_defer_mon" type="text" class="text w100p right" /> </td>
		<td class="center"> <input id="a_ret_mon" name="a_ret_mon" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"> <input id="k_cal_defer_tax_mon" name="k_cal_defer_tax_mon" type="text" class="text w100p right transparent" readonly /> </td>
	</tr>
	</table>
	<!-- table5 -->
	<div class="outer">
    <div class="sheet_title">
        <ul>
            <li class="txt">[납부명세]
            </li>
            <li class="btn">
    		</li>
        </ul>
    </div>
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="table inner">
	<colgroup>
        <col width="20%" />
        <col width="20%" />
        <col width="20%" />
        <col width="20%" />
        <col width="20%" />    
	</colgroup>
	<tr>
		<th class="center">구분</th>
		<th class="center">소득세</th>
		<th class="center">지방소득세</th>
		<th class="center">농어촌특별세</th>
		<th class="center">계</th>
	</tr>
	<tr>
		<th >신고대상액</th>
		<td class="center"> <input id="a_declare_itax_mon" name="a_declare_itax_mon" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"> <input id="a_declare_rtax_mon" name="a_declare_rtax_mon" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"> <input id="a_declare_stax_mon" name="a_declare_stax_mon" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"> <input id="a_t_declare_mon_tot" name="a_t_declare_mon_tot" type="text" class="text w100p right transparent" readonly/> </td>
	</tr>
	<tr>
		<th >이연퇴직소득세</th>
		<td class="center"> <input id="k_cal_defer_tax_mon" name="k_cal_defer_tax_mon" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"> <input id="k_div_cal_defer_tax_mon" name="k_div_cal_defer_tax_mon" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"></td>
		<td class="center"> <input id="k_cal_defer_tax_mon_tot" name="k_cal_defer_tax_mon_tot" type="text" class="text w100p right transparent" readonly/> </td>
	</tr>
	<tr>
		<th >차감원천징수세액</th>
		<td class="center"> <input id="a_t_itax_mon" name="a_t_itax_mon" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"> <input id="a_t_rtax_mon" name="a_t_rtax_mon" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"> <input id="a_t_stax_mon" name="a_t_stax_mon" type="text" class="text w100p right transparent" readonly/> </td>
		<td class="center"> <input id="a_t_tax_tot" name="a_t_tax_tot" type="text" class="text w100p right transparent" readonly/> </td>
	</tr>
	</table>
	</div>
	</div>
	
	<span class="hide" style="height:500px">
		<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
	</span>
</div>

</body>
</html>