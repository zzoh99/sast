<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<base target="_self" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<script src="${ctx}/common/plugin/ckeditor5/ckeditor.js"></script>
<title><tit:txt mid='emailSend' mdef='MAIL 발신'/></title>
<script type="text/javascript">
	var MAIL_SEND_FLAG = true;
	var p = eval("${popUpStatus}");
	var arg_col = "";
	var arg_val = "";
	var arg_sender= "";
	
	$(function(){
		const modal = window.top.document.LayerModalUtility.getModal('mailMgrLayer');
	    var arg =  modal.parameters;
	    
	    var arg_bizCd = arg.bizCd || "";
	    var saveType   = arg.saveType || "";
	    var names = arg.names || "";
	    var mailIds = arg.mailIds || "";
	
	    /*
		var arg_bizCd 	= "";
		var saveType  	= "";
		var names		= "";
		var mailIds	 = "";
	
		var arg = p.popDialogArgumentAll();
		if( arg != undefined ) {
			names      = arg["names"];
			mailIds    = arg["mailIds"];
			saveType   = arg["saveType"];
			arg_bizCd  = arg["bizCd"];
			arg_sender = arg["sender"];
			arg_col    = arg["col"];
			arg_val    = arg["val"];
		}
		
		*/

		if(names.split("|") != ""){
			reciveMail(names,mailIds);
		}
		$("#saveType").val(saveType);
	
		//Editor.getCanvas().setCanvasSize({height:$(document).height()-450});
	
		//var bizCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10060"), "<tit:txt mid='111914' mdef='선택'/>");
		var bizCd 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getNoticeTemplateBizCdListForCombo",false).codeList, "<tit:txt mid='111914' mdef='선택'/>");
		$("#bizCd").html(bizCd[2]);
		$("#bizCd").val(arg_bizCd);
	
		htmlLoad();
	
		//Cancel 버튼 처리
		$(".close").click(function(){
			//p.self.close();
			closeLayerModal();
		});
	
		// 호출구분
		$("#bizCd").change(function(){
			htmlLoad();
		});
	
		$("#recevers").bind("keyup",function(event){
			if(event.keyCode == 46 || event.keyCode == 8){
				if(this.length>0)
					this.options[this.options.selectedIndex] = null;
			}
		});
	
		//upLoadInit("","${mail}");
	});
	
	function htmlLoad(){
		// 입력 폼 값 셋팅
	
		var data = ajaxCall("${ctx}/Send.do?cmd=getMailContent",$("#dataForm").serialize(),false);
	
		if(data.map == null){
			$("#mailTitle").val("");
			$("#hiddenContent").html("");
		}
		else {
			$("#mailTitle").val(data.map.mailTitle);
			$("#hiddenContent").html(setMailContent(data.map.mailContent));
			if($("#bizCd").val() == "227"){
				var data = ajaxCall("${ctx}/Send.do?cmd=getMailId",$("#dataForm").serialize(),false);
				if(data.map != null){
					if(data.map.mail != ""){
						$("#fromMail").val(data.map.mail);
					}
				}
			}else{
				//tag 컬럼에서 mailTo 값이 있을 경우 발신자 메일에 세팅
				if(data.map.tag != null && data.map.tag !=""){
					var mbj = eval("({"+data.map.tag+"})");
					$("#fromMail").val(mbj.mailTo);
				}
			}

			$('#modifyContents').val(setMailContent(data.map.mailContent));
		}
		callIframeBody("authorForm", "authorFrame");
		$('#authorFrame').on("load", function() { setIframeHeight("authorFrame"); });
	}
	
	function setMailContent(pVal) {
		try{
			if ( $("#bizCd").val() == "99999" ) {
				/*
				1. 과정명(회차명) : #eduCourseNm#(#eduEventNm#)
				2. 교육목표 : #eduCourseGoal#
				3. 교육대상 : #eduTarget#
				4. 교육일시 : #eduSYmd# #eduSHm# ~ #eduEYmd# #eduEHm#
				5. 장소 : #eduPlace#
				6. 교육내용 : #eduMemo#
				7. 기타안내 :
				*/
				var arrCol = arg_col.split("¿");
				var arrVal = arg_val.split("¿");
	
				for (var i=0; i<arrCol.length; i++) {
					pVal = pVal.replace(arrCol[i], arrVal[i]);
				}
			}
	
		}catch(e){
			alert("setMailContent::" + e);
		}
	
		return pVal;
	}
	
	function reciveMail(names,mailIds){

		var rNm   = names.split("|");
		var rMail = mailIds.split("|");
		if(rMail.length != rNm.length) {
			alert("<msg:txt mid='errorMailReceiptCnt' mdef='수신메일주소와 수신메일명의 개수가 같지 않습니다.\n관리자에게 문의해 주세요.'/>");
			return;
		} else {
			for(i = 0; i < rMail.length; i++) {
				mailSpanAdd("recever",rNm[i],rMail[i],"Y");
			}
		}
	}
	
	function referenceMail(names,mailIds){
		var rNm   = names.split("|");
		var rMail = mailIds.split("|");
		if(rMail.length != rNm.length) {
			alert("<msg:txt mid='errorMailReceiptCnt' mdef='수신메일주소와 수신메일명의 개수가 같지 않습니다.\n관리자에게 문의해 주세요.'/>");
			return;
		} else {
			for(i = 0; i < rMail.length; i++) {
				mailSpanAdd("reference",rNm[i],rMail[i],"Y");
			}
		}
	}
	
	function fnSend(){
		if($("#bizCd").val()==""){
			alert('<msg:txt mid='alertMailFormat' mdef='기본서식을 선택해주세요.'/>');
			return;
		}
	
		if($("#fromMail").val()==""){
			alert('발신자 메일주소를 입력해주세요.');
			return;
		}
	
		////발신을 2번 방지
		if(!MAIL_SEND_FLAG){
			alert("<msg:txt mid='alertBeingSend' mdef='발송중입니다.\n잠시만 기다려 주세요.'/>");
			return;
		}else{
			MAIL_SEND_FLAG = false;
		}

		ckReadySave("authorFrame");

		if(ckGetContent("authorFrame")){
			pSendMail();
		}else{
			MAIL_SEND_FLAG = true;
		}
	}
	
	function pSendMail(){
		var receverStr = "";
		var referenceStr = "";
	
		$(":input[type=hidden]",$("#receverTd")).each(function(){
			if($(this).val()!=""){
				if(receverStr != ""){
					receverStr += "^";
				}
				receverStr += $(this).val();
			}
		});
	
		$(":input[type=hidden]",$("#referenceTd")).each(function(){
			if($(this).val()!=""){
				if(referenceStr != ""){
					referenceStr += "^";
				}
				referenceStr += $(this).val();
			}
		});
	
		if(arg_sender != undefined && arg_sender != null && arg_sender != "") {
			$("#sender").val(arg_sender);
		} else {
			$("#sender").val("${ssnSabun}");  //보내는 사람
		}
	
		$("#receverStr").val(receverStr); //보낼사람
		$("#referenceStr").val(referenceStr); //참조
		$("#receiveType").val("00");	  //현재는 필요없는 값[하드코딩할 경우 필요]
		//$("#fromMail").val("dolmangi@gmail.com"); //보내는 사람 메일
	
	// 	for(var i = supSheet.HeaderRows(); i<supSheet.RowCount()+supSheet.HeaderRows(); i++){
	// 		if(supSheet.GetCellValue(i, "sFileNm")==""){
	// 			alert('파일을 업로드 해주세요.');
	// 			MAIL_SEND_FLAG = true;
	// 			return;
	// 		}
	// 		$("#fileStr").val($("#fileStr").val()+supSheet.GetCellValue(i, "sFileNm")+"|");
	// 		$("#orgFileNm").val($("#orgFileNm").val()+supSheet.GetCellValue(i, "rFileNm")+"|");
	// 	}
		$("#fileStr").val($("#fileStr").val().substring(0,$("#fileStr").val().length-1));
		$("#orgFileNm").val($("#orgFileNm").val().substring(0,$("#orgFileNm").val().length-1));
		//return;
	
	   	try{
			result = ajaxCall("/Send.do?cmd=callMail",$("#dataForm").serialize(),false).result;
			//result = ajaxCall("/Send.do?cmd=callMailType3",$("#dataForm").serialize(),false).result;
			alert(result);
	
		} catch(ee){}
	
	
		//p.self.close();
		closeLayerModal();
	
	}
	
	
	$(function() {
		var url = "/SendMgr.do?cmd=getMailInfo2";
		initEmployeeHeader("recever",url,employeeResponse);
		initEmployeeHeader("reference",url,employeeResponse);
		$("#recever").on("keyup", function(event){
			if(event.keyCode == "13"){
				var myRe=/^([/\w/g\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
				if(!myRe.test($(this).val())){
					return;
				}else{
					reciveMail("", $(this).val());
					$(this).val("");
				}
			}
		});
	
		$("#reference").on("keyup", function(event){
			if(event.keyCode == "13"){
				var myRe=/^([/\w/g\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
				if(!myRe.test($(this).val())){
					return;
				}else{
					referenceMail("", "", $(this).val());
					$(this).val("");
				}
			}
		});
	});
	
	function initEmployeeHeader(inputId,url,employeeResponse) {
		$("#"+inputId).autocomplete(employeeOption(inputId,url,employeeResponse)).data("uiAutocomplete")._renderItem = employeeRenderItem;
	}
	
	function employeeOption(inputId,url,formId,employeeResponse) {
		return {
			source: function( request, response ) {
				$.ajax({
					url :url,
					dateType : "json",
					type:"post",
					data: "searchKeyword="+encodeURIComponent($("#"+inputId).val()),
					async: false,
					success: function( data ) {
						response( $.map( data.result, function( item ) {
							return {
								label: "",
								searchId	:   inputId,
								sabun 		:	item.sabun,
								name 		:	item.name,
								mailId 		:	item.mailId
							};
						}));
					},
					error:function(e){
						alert(e.responseText);
					}
				});
			},
			minLength: 1,
			select: employeeReturn,
			focus: function() {
				return false;
			},
			open: function() {
				$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
				document.querySelectorAll(".ui-autocomplete").forEach((_el) => _el.style.setProperty("z-index", 999, "important"));
			},
			close: function() {
				$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
			}
		};
	}
	
	function employeeRenderItem(ul, item) {
	
		return $("<li />")
			.data("item.autocomplete", item)
			.append("<a class='employeeLIst'>"
			+"<span class='list_txt0'>"+String(item.name).split(item.searchNm).join('<b>'+item.searchNm+'</b>')+"</span>"
			+"<span class='list_txt1'>"+item.sabun+"</span>"
			+"<span class='list_txt2'>"+item.mailId+"</span>"
			+"</a>").appendTo(ul);
	}
	
	function employeeResponse() {
		return {
			label: item.empName + ", " + item.enterCd  + ", " + item.enterNm,
			searchNm : $("#"+inputId).val(),
			sabun 		:	item.sabun,
			name 		:	item.name,
			mailId 		:	item.mailId
		};
	}
	
		// 리턴 값
	function employeeReturn( event, ui ) {
			mailSpanAdd(ui.item.searchId,ui.item.name,ui.item.mailId);
	}
	
	function mailSpanAdd(inputBoxId,displayText,displayMailId,firstYn){
			var sameResult=false;
			$("div",$("#"+inputBoxId).parent()).each(function(){
				if($(this).text()==displayText+"("+displayMailId+")"){
					sameResult=true;
				}
			});
			if(sameResult){
				//firstYn화면열리면서 실행될경우는 알럿필요없음
				if(firstYn!="Y"){
					alert('<msg:txt mid='alertSelectEmail' mdef='이미 선택된 메일주소 입니다.'/>');
				}
				return;
			}
			var tbodyNumber=$("div",$("#"+inputBoxId).parent()).length%3;
	
			//$("#"+inputBoxId).before(
			$("#"+inputBoxId+"Td"+tbodyNumber).append(
					$("<div/>", {
						"class" : "disp_flex alignItem_center justify_between bd_r5 point_bg_base pad-x-8 mat5 f_s11"
					}).append(
						$("<span/>", {
							"title" : displayText + " ("+displayMailId+")",
							"class" : "ellipsis pointer",
							"style" : "width: calc(100% - 15px)"
						}).text(displayText + " ("+displayMailId+")")
					).append(
						$("<img/>", {
							"src"   : "/common/images/common/btn_close_gray.gif",
							"class" : "mal5"
						}).click(function(){
							$(this).parent().remove();
							relocation(inputBoxId);
						})
					).append(
						$("<input/>", {
							"type" : "hidden",
							"name" : inputBoxId+"Mail",
							"id"   : inputBoxId+"Mail"
						}).val(displayMailId)
					)
			);
	}
	
	function relocation(inputBoxId){
		$("div",$("#"+inputBoxId).parent()).each(function(index){
			$("#"+inputBoxId+"Td"+index%3).append(
			 $(this)
			);
		});
	}
	
	function addRecever(){
		if($("#addReceverName").val() == ""){
			alert("<msg:txt mid='110123' mdef='이름을 입력해주세요.'/>");
		}else if($("#addReceverAddr").val() == ""){
			alert("주소를 입력해주세요.");
		}else{
			mailSpanAdd($("#addAddrType").val(),$("#addReceverName").val(),$("#addReceverAddr").val(),"Y");
			$("#addReceverName").val("");
			$("#addReceverAddr").val("");
		}
	}
	
	function closeLayerModal(){
	    const modal = window.top.document.LayerModalUtility.getModal('mailMgrLayer');
	    modal.hide();
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
<!-- 
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='emailSend' mdef='MAIL 발신'/></li>
		<li class="close"></li>
	</ul>
	</div>
 -->
	<div class="modal_body">
		<form id="authorForm" name="form">
			<input type="hidden" id="modifyContents" name="modifyContents"	/>
			<input type="hidden" id="height" name="height" value="415" />
		</form>
		<form id="dataForm" name="dataForm" >
			<input type="hidden" id="enterCd" 		name="enterCd" value="${sessionScope.ssnEnterCd}" />
			<input type="hidden" id="sabun" 		name="sabun" value="${ssnSabun}" />
			<input type="hidden" id="sender" 		name="sender"  />
			<input type="hidden" id="saveType" 		name="saveType"  />
			<input type="hidden" id="receiveType" 	name="receiveType"  />
			<input type="hidden" id="fileStr" 		name="fileStr"  />
			<input type="hidden" id="orgFileNm" 	name="orgFileNm"  />
			<input type="hidden" id="filePath" 		name="filePath" value="${mail}"  />
			<input type="hidden" id="receverStr" 	name="receverStr" value=""  />
			<input type="hidden" id="referenceStr" 	name="referenceStr" value=""  />
			<!-- <textarea id="mailContent" name="mailContent" Row="0" Col="0" class="hide"></textarea> -->
			<!-- ckEditor -->
             <input type="hidden" id="ckEditorContentArea" name="contents">
	
			<table class="table">
				<colgroup>
					<col width="15%" />
					<col width="" />
				</colgroup>
				<tr>
					<th class="left"><tit:txt mid='112699' mdef='기본서식'/></th>
					<td >
						<select id="bizCd" name="bizCd"></select>
					</td>
				</tr>
				<tr>
					<th class="left"><tit:txt mid='103918' mdef='제목'/></th>
					<td ><input type="text" id="mailTitle" name="mailTitle" class="text w100p"></td>
				</tr>
				<tr>
					<th class="left"><tit:txt mid='113784' mdef='발신자'/></th>
					<td ><input type="text" id="fromMail" name="fromMail" class="text w100p"></td>
				</tr>
				<tr class="hide">
					<th class="left"><tit:txt mid='104207' mdef='추가'/></th>
					<td>
						<span><tit:txt mid='103997' mdef='구분'/></span>
						<select id = "addAddrType" name="addAddrType">
							<option value="recever">수신자</option>
							<option value="reference">참조자</option>
						</select>
						<span><tit:txt mid='103915' mdef='이름'/></span>
						<input id = "addReceverName" name = "addReceverName" class = "text"/>
						<span><tit:txt mid='address' mdef='주소'/></span>
						<input id = "addReceverAddr" name = "addReceverAddr" class = "text w50p"/>
						<button id = "addReceverBtn" name = "addReceverBtn" class = "button" onclick = "addRecever();">추가</button>
					</td>
				</tr>
				<tr>
					<th class="left"><tit:txt mid='114137' mdef='수신자'/></th>
					<td class="valignT padl10 padr5" id="receverTd">
						<div onclick="$('#recever').focus();" class="mail_text w100p" >
							<table class="table_mail w100p">
								<colgroup>
									<col width="33%" />
									<col width="33%" />
									<col width="34%" />
								</colgroup>
								<tbody>
									<tr>
										<td id="receverTd0" class="valignT padr1 padb10"></td>
										<td id="receverTd1" class="valignT padr1 padb10"></td>
										<td id="receverTd2" class="valignT padr1 padb10"></td>
									</tr>
								</tbody>
							</table>
							<i class="fas fa-user-plus mal10 mar5"></i>
							<input id="recever" name="recever" style="ime-mode:active;" class="f_gray_6 ma-y-5 pad-x-10 bd_r15 bd_solid" />
						</div>
					</td>
				</tr>
				<tr class="hide">
					<th class="left"><tit:txt mid='112372' mdef='참조자'/></th>
					<td class="valignT padl10 padr5" id="referenceTd">
						<div onclick="$('#reference').focus();" class="mail_text w100p" >
							<table class="table_mail w100p">
								<colgroup>
									<col width="33%" />
									<col width="33%" />
									<col width="34%" />
								</colgroup>
								<tbody>
									<tr>
										<td id="referenceTd0" class="valignT padr1 padb10"></td>
										<td id="referenceTd1" class="valignT padr1 padb10"></td>
										<td id="referenceTd2" class="valignT padr1 padb10"></td>
									</tr>
								</tbody>
							</table>
							<i class="fas fa-user-plus mal10 mar5"></i>
							<input id="reference" name="reference" style="ime-mode:active;" class="f_gray_6 ma-y-5 pad-x-10 bd_r15 bd_solid" />
						</div>
					</td>
				</tr>
<!--
				<tr>
					<th colspan="2" class="center"><tit:txt mid='104429' mdef='내용'/></th>
				</tr>
 -->
				<tr>
					<td colspan="2" class="pad5 pad-y-10">
						<iframe id="authorFrame" name="authorFrame" frameborder="0" class="author_iframe"></iframe>
					</td>
				</tr>
<!--
				<tr>
					<td colspan="2">
						<div id="uploadDiv">
							<%--<%@ include file="/WEB-INF/jsp/common/popup/uploadMgrForm.jsp"%> --%>
						</div>
					</td>
				</tr>
-->
			</table>
		</form>
		<div id="hiddenContent" style="display:none"></div>
	</div>
     <div class="modal_footer">
	     <a href="javascript:fnSend();" class="btn filled"><tit:txt mid='114142' mdef='발신'/></a>
	     <a href="javascript:closeLayerModal();" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
     </div>
        
</div>
</body>
</html>
