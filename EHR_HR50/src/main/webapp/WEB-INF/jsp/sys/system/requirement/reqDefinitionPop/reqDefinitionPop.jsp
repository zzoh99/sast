<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>요구사항 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<style type="text/css">
</style>
<script type="text/javascript">

var p = eval("${popUpStatus}");

	$(function() {

		$("input[type='text']").keydown(function(event){ 
			if(event.keyCode == 27){
				return false;
			}
		});
		
		$(".close").click(function(){
			p.self.close();
		});
		
		
		var arg = p.window.dialogArguments;
		var surl 			= "";
		var location  		= "";
		
		if( arg != undefined ) {
			surl 	   = arg["surl"];
			location   = arg["location"];
		}else{
			if ( p.popDialogArgument("surl") !=null ) { 	surl			   			= p.popDialogArgument("surl"); }
			if ( p.popDialogArgument("location") !=null ) { location		   			= p.popDialogArgument("location"); }
		}

		if ( location != "" ){
			$("#locationPopup").html(location);
		}
		if ( surl != "" ){
			$("#surl").val(surl);
		}

		$("#regYmd").val("${curSysYyyyMMddHyphen}");

		$("#regNote").maxbyte(3500);
		
//--------------------------------------------------------------------------------------------------------

		var proNameList	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S99997"), "");
		$("#proName").html("<option value=''></option>"+proNameList[2]);
		$("#regName").html("<option value=''></option><option value='${ssnName}'>${ssnName}</option>"+proNameList[2]);
		$("#regName").val("${ssnName}");


		var searchRegCd	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S99991"), "<tit:txt mid='111914' mdef='선택'/>");
		
		$("#searchRegCd").html(searchRegCd[2]);
		$("#searchRegCd option:eq(1)").prop("selected", true);
		$("#searchRegCd option:not(option:selected)").remove();
		
		$(":checkbox").click(function(event){
			
			$("#searchRegCd option").remove();
			
			if($(this).attr("id") == "searchError" && $(this).is(":checked") == true ){
				
				$("#searchRegCd").html(searchRegCd[2]);
				$("#searchRegCd option:eq(2)").prop("selected", true);
				$("#searchRegCd option:not(option:selected)").remove();
				$("#regNote").val("테스트 결과 정상입니다.");
				//$("#regNote").attr("readonly", true);
				//$("#regNote").addClass("readonly").removeClass("required");
				$("#regNote").attr("readonly", false);
				$("#regNote").removeClass("readonly").addClass("required");
				
			}else{
				
				$("#searchRegCd").html(searchRegCd[2]);
				$("#searchRegCd option:eq(1)").prop("selected", true);
				$("#searchRegCd option:not(option:selected)").remove();
				$("#regNote").val("");
				$("#regNote").attr("readonly", false);
				$("#regNote").removeClass("readonly").addClass("required");;
				
			}
		});
//--------------------------------------------------------------------------------------------------------
		
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		
		case "Save":
			
						if(!checkList()) return ;
						
						if (confirm( "저장하시겠습니까?")) {

							try{

								var rtn = ajaxCall("${ctx}/ReqDefinitionPop.do?cmd=saveReqDefinitionPop",$("#sendForm").serialize(),false);

								if(rtn.Result.Code > 0) {
									alert(rtn.Result.Message);
								}else{
									alert(rtn.Result.Message);
									return;
								}
							} catch (ex){
								alert("저장중 스크립트 오류발생." + ex);
							}
							var rv = new Array();
							p.popReturnValue(rv);
							p.window.close();
						}
						break;
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
				alert($(this).parent().prev().text()+"은(는) 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}
		});
		return ch;
	}
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li id="locationPopup"></li>
			<li class="close"></li>
		</ul>
	</div>
	
<form id="sendForm" name="sendForm" method="POST">

	<input type="hidden" id="surl" name="surl" value="" />
	
	<div class="popup_main">
		<table class="table">
		<colgroup>
			<col width="120px" />
			<col width="30%" />
			<col width="120px" />
			<col width="" />
		</colgroup>
		<tr>
			<th align="center">등록자</th>
			<td>
			
				<select id="regName" name="regName"></select>
			</td>
			<th align="center">등록일</th>
			<td>
				<input type="text" id="regYmd" name="regYmd" class="text center readonly" maxlength="10" value="" style="width: 80px;" readonly="readonly" />  
			</td>
		</tr>
		<tr>
			<th align="center">등록구분</th>
			<td>
				<select id="searchRegCd" name="searchRegCd" class="box required" style="margin-right: 20px;"></select>
				<input type="checkbox" id="searchError" name="searchError" style="position: relative; top: 3px;" /><label for="searchError">오류없음(오류없는경우 체크)</label>
			</td>
			<th align="center">처리자</th>
			<td>
				<select id="proName" name="proName"></select>
			</td>
		</tr>	
		<tr>
			<th align="center"><tit:txt mid='104429' mdef='내용'/></th>
			<td colspan="3">
				<textarea id="regNote" name="regNote" class="required" rows="10" cols="10" style="width: 100%; ime-mode:active;"></textarea>
			</td>
		</tr>
		</table>
</form>
		<div class="popup_button">
			<ul>
				<li>
					<a href="javascript:doAction1('Save');" class="button large"><tit:txt mid='104476' mdef='저장'/></a>
					<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>
