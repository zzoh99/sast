<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>교육이력관리 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<style type="text/css">
</style>
<script type="text/javascript">
var p = eval("${popUpStatus}");
$(function(){
	var nationalCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20290"), "");	//소재국가
	
	$("#nationalCd").html(nationalCd[2]);
	
	$("#fiYear").bind("keyup",function(event){
		makeNumber(this,"A");
	});	
	
	var arg = p.window.dialogArguments;
	var sheet1	= arg["sheet1"]        ;  
	var Row		= arg["Row"]        ;  
	
	//$("#eduOrgCd").val(eduOrgCd        		) ;
	//mainEduOrgYn == "Y" ? $(':checkbox[name=mainEduOrgYn]').attr('checked', true) : $(':checkbox[name=mainEduOrgYn]').attr('checked', false) ; 
	
	// 숫자만 입력
	/*
	$("#orderSeq").keyup(function() {
	     makeNumber(this,'A') ;
	 });
	*/
	//Cancel 버튼 처리 
	$(".close").click(function(){
		p.self.close(); 
	});
});

function setValue() {
	var rv = new Array();
	rv["eduOrgCd"]        = $("#eduOrgCd").val() ;    
	rv["eduOrgNm"]        = $("#eduOrgNm").val() ;   

	var temp = "N" ;
	$("#mainEduOrgYn").is(":checked") == true ? temp = "Y" : temp = "N" ;
	rv["mainEduOrgYn"]    = temp ;
	
	rv["nationalCd"]      = $("#nationalCd").val() ;   
	rv["zip"]             = $("#zip").val() ;    
	rv["curAddr1"]        = $("#curAddr1").html() ;    
	rv["curAddr2"]        = $("#curAddr2").val() ;    
	rv["bigo"]            = $("#bigo").val() ;    
	rv["chargeName"]      = $("#chargeName").val() ;    
	rv["orgNm"]           = $("#orgNm").val() ;    
	rv["jikweeNm"]        = $("#jikweeNm").val() ;    
	rv["telNo"]           = $("#telNo").val() ;    
	rv["telHp"]           = $("#telHp").val() ;    
	rv["faxNo"]           = $("#faxNo").val() ;    
	rv["email"]           = $("#email").val() ;    
	rv["companyNum"]      = $("#companyNum").val() ;    
	rv["companyHead"]     = $("#companyHead").val() ;    
	rv["businessPart"]    = $("#businessPart").val() ;    
	rv["businessType"]    = $("#businessType").val() ;    
	rv["bankNum"]         = $("#bankNum").val() ;    
	rv["bankCd"]          = $("#bankCd").val() ;    
	rv["mainEduOrgYn_STR"]= $("#mainEduOrgYn_STR").val() ; 
	
	p.window.returnValue = rv;                   
	p.window.close(); 
}

// 팝업 클릭시 발생
function zipCodePopup() {
    var rst = openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740","620");
    if(rst != null){
    	$("#zip").val(rst["zip"]);	
    	$("#curAddr1").html(rst["sido"]+ " "+ rst["gugun"] +" " + rst["dong"]+" " + rst["bunji"]);
    }
}


function doSearchEduOrgNm() {
	var rst = openPopup("/Popup.do?cmd=eduOrgPopup&authPg=R", "", "550","520");   
    if(rst != null){
    	//$("#eduOrgCd").val(rst["eduOrgCd"]);
    	$("#eduOrgNm").val(rst["eduOrgNm"]);
    }		
    //popupGubun = "FORM";
    //var openWindow = CenterWin("/JSP/popup/EduOrg_popup.jsp", "EduOrg_popup", "scrollbars = no, status = no, width = 540, height = 520, top = 0, left = 0");
}
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='eduHistoryLstPop' mdef='교육이력관리 세부내역'/></li>
			<li class="close"></li>
		</ul>
	</div>
	
	<div class="popup_main">
		<table class="table">
			<colgroup>
				<col width="15%" />
				<col width="15%" />
				
				<col width="15%" />
				<col width="15%" />
				
				<col width="15%" />
				<col width="15%" />
				
				<col width="15%" />
				<col width="15%" />
			</colgroup>
			<tr>
				<th>회계년도</th>
				<td>				
					<input id="fiYear" name="fiYear" type="text" class="text" style="width:99%;" maxlength="4"/>
				</td>
				<th><tit:txt mid='104168' mdef='과정명'/></th>
				<td colspan="4">				
					<input id="eduCourseNm" name="eduCourseNm" type="text" class="text" style="width:99%;" />
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='201705160000123' mdef='교육대상'/></th>
				<td>				
					<input id="eduTarget" name="eduTarget" type="text" class="text w100p"/>
				</td>
				<th><tit:txt mid='201705040000019' mdef='필수여부'/></th>
				<td>
					<select id="mandatoryYn" name="mandatoryYn">
					</select> 	
				</td>
				<th>교육체계</th>
				<td>				
					<select id="eduMBranchCd" name="eduMBranchCd">
					</select> 	
				</td>
				<th>교육인원</th>
				<td>
					<input id="maxPerson" name="maxPerson" type="text" class="text w100p"/>				
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='eduOrgPopV1' mdef='교육기관'/></th>
				<td>
					<input id="eduOrgCd" name="eduOrgCd" type="hidden" class=""/> 
					<input id="eduOrgNm" name="eduOrgNm" type="text" class="text w50p"/> 
					<a href="javascript:doSearchEduOrgNm();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				</td>
				<th>교육예산</th>
				<td>
					<input id="eduBudget" name="eduBudget" type="text" class="text w100p"/>	
				</td>
				<th>교육형태</th>
				<td>				
					<select id="eduMBranchCd" name="eduMBranchCd">
					</select> 	
				</td>
				<th><tit:txt mid='103997' mdef='구분'/></th>
				<td>				
					<select id="inOutType" name="inOutType">
					</select> 	
				</td>
			</tr>
			<tr>
				<th>과정목표<br>(학습목표)</th>
				<td colspan="7">
					<textarea id="eduCourseGoal" name="eduCourseGoal" rows="3" class="text w100p"></textarea>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='114508' mdef='과정내용'/></th>
				<td colspan="7">
					<textarea id="eduMemo" name="eduMemo" rows="3" class="text w100p"></textarea>
				</td>
			</tr>
		</table>
		<div class="popup_button">
			<ul>
				<li>
					<a href="javascript:setValue();" class="pink large authA"><tit:txt mid='104435' mdef='확인'/></a>
					<a href="javascript:p.self.close();" class="gray large authR"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>
