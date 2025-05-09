<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>월근태/근무집계</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/ui/jquery.progressbar.min.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">

	$(function() {
        $("#progressBar").progressBar(0);

		//근무조
		//var searchWorkteamCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTorg109List&mapTypeCd=500",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		var searchWorkteamCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTimWorkTeamCodeList",false).codeList, "전체");
		$("#searchWorkteamCd").html(searchWorkteamCdList[2]);

        //사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
        var url     = "queryId=getBusinessPlaceCdList";
        var allFlag = "<tit:txt mid='103895' mdef='전체'/>";
        if ("${ssnSearchType}" != "A"){
            url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
            allFlag = "";

            var searchOrgUrl = "queryId=getTSYS319orgList&ssnSearchType=${ssnSearchType}&ssnGrpCd=${ssnGrpCd}&searchSabun=${ssnSabun}";
            //var searchOrgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", searchOrgUrl,false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
            var searchOrgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", searchOrgUrl,false).codeList, "");
            $("#searchOrgCd").html(searchOrgCdList[2]);
        }
        var bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", url,false).codeList, allFlag);
        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);
        
		$("#searchSym, #searchEym").datepicker2({
			ymonly:true,
			onReturn:function(date){
				doAction1("Search");
			}
		});

		$("#searchSym, #searchEym").bind("keyup", function(event) {
			if( event.keyCode == 13 ) {
				doAction1("Search");
			}
		}) ;
		$("#searchSym, #searchEym").bind("keydown", function(event) {
			if( event.keyCode == 13 ) {
				doAction1("Search");
			}
		}) ;
		$("#searchWorkteamCd").bind("change", function(event) {
			doAction1("Search");
		}) ;

		doAction1("Search");
	});

	//Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			if($("#searchSym").val() == "" || $("#searchEym").val() == "") {
				alert("<msg:txt mid='alertWorkHourFlxAppDet2' mdef='대상기간을 입력하여 주십시오.'/>");
				return;
			}

			var data = ajaxCall("${ctx}/WorkOrgScheduleCre.do?cmd=getWorkOrgScheduleCre", $("#dataForm").serialize(),false);

			$("#creYn").attr("checked", false);

			if(data != null && data.DATA != null) {

				if(data.DATA.creYn == 'Y') {
					$("#creYn").attr("checked", true);
				}
			}
			break;
		case "Cre":
			//진행률 초기화
			clearProgress();
			
			if( ($("#searchSym").val() == "" || $("#searchEym").val() == "")
			 || ($("#searchSym").val() > $("#searchEym").val()) ) {
				alert("<msg:txt mid='110548' mdef='대상기간을 정확히 입력하여 주십시오.'/>");
				return;
			}

			var confirmMsg = ($("#searchWorkteamCd").val() == "")?"":"근무조:"+$("#searchWorkteamCd option:selected").text()+"\r\n";
			if ( $("#searchSabun").val() != "" ){
				confirmMsg    += "[사번 :" +$("#searchSabun").val() + ", 성명:"+$("#name").val() +"]\r\n";
			}
			confirmMsg    += "[기간: "+$("#searchSym").val()+"~"+$("#searchEym").val()+"]"+ " \r\n근무스케쥴 정보를 생성 하시겠습니까?" ;

			if(!confirm(confirmMsg)) { return ;}

			clearProgress();

			$.ajax({
		        url: "${ctx}/WorkOrgScheduleCre.do?cmd=prcWorkOrgScheduleCre",
		        type: "post",
		        dataType: "json",
		        async: true,
		        data: $("#dataForm").serialize()
		    });
			
			setTimeout(function(){
				$(".waitBox").show();
				
				getProgressStatus(1);
			}, 500);
			/*
			
			progressBar(true) ;
			
			setTimeout(
				function(){
					var data = ajaxCall("${ctx}/ExecPrc.do?cmd=prcWorkOrgScheduleCre", $("#dataForm").serialize(),false);
			    	if(data.Result.Code == null) {
			    		alert("<msg:txt mid='109663' mdef='정상적으로 처리되었습니다.'/>");
				    	progressBar(false) ;
			    	} else {
				    	alert("처리중 오류가 발생했습니다.\n"+data.Result.Message);
				    	progressBar(false) ;
			    	}
				}
			, 100);*/
			break;
		case "Cre2":
			//진행률 초기화
			clearProgress();
			
			if( ($("#searchSym").val() == "" || $("#searchEym").val() == "")
			 || ($("#searchSym").val() > $("#searchEym").val()) ) {
				alert("<msg:txt mid='110548' mdef='대상기간을 정확히 입력하여 주십시오.'/>");
				return;
			}

			var confirmMsg = ($("#searchWorkteamCd").val() == "")?"":"근무조:"+$("#searchWorkteamCd option:selected").text()+"\r\n";
			if ( $("#searchSabun").val() != "" ){
				confirmMsg    += "[사번 :" +$("#searchSabun").val() + ", 성명:"+$("#name").val() +"]\r\n";
			}
			confirmMsg    += "[기간: "+$("#searchSym").val()+"~"+$("#searchEym").val()+"]"+ " \r\n근무이력을 갱신 하시겠습니까?" ;

			if(!confirm(confirmMsg)) { return ;}
			
			clearProgress();
			

			$.ajax({
		        url: "${ctx}/WorkOrgScheduleCre.do?cmd=prcWorkOrgScheduleCre2",
		        type: "post",
		        dataType: "json",
		        async: true,
		        data: $("#dataForm").serialize()
		    });
			
			setTimeout(function(){$(".waitBox").show();getProgressStatus(2);}, 500);
			
			break;
		}
	}

	// 사원 팝업
	function showEmployeePopup() {
		let layerModal = new window.top.document.LayerModal({
			id : 'employeeLayer'
			, url : '/Popup.do?cmd=viewEmployeeLayer'
			, parameters : {}
			, width : 840
			, height : 520
			, title : '사원조회'
			, trigger :[
				{
					name : 'employeeTrigger'
					, callback : function(result){
						$('#searchSabun').val(result.sabun);
						$('#name').val(result.name);
					}
				}
			]
		});
		layerModal.show();
	}

	//진행상태 표시
	function getProgressStatus(flag){
		var data = ajaxCall( "${ctx}/WorkOrgScheduleCre.do?cmd=getWorkOrgScheduleProgress", "flag="+flag,false);
		if ( data != null && data.DATA != null ){ 
			
			try{
				var per = Number(data.DATA.per);
				
		        $("#progressBar").progressBar(per);
		        
				if( per != "100" ){
					setTimeout(function(){ getProgressStatus(flag); }, 2000);
				}else{
					$("#span_msg").html("처리 완료 했습니다.");$(".waitBox").hide();
				}
			}catch(e){
				$("#span_msg").html(data.DATA.log);$(".waitBox").hide();
			}
			
		}
			
	}
	
	//진행상태 초기화
	function clearProgress(){
		$("#progressBar").progressBar(0);
		$("#span_msg").html("");
	}

	    
	   
</script>
<style type="text/css">
.waitBox {display:none;}
.waitDiv {position:absolute; width:100%; height:100%; top:0; left:0;z-index:997; text-align:center; vertical-align:middle; background-color:gray;opacity: 0.4;}
.waitDivBox {position:absolute; top:300px; left:50%; margin-left:-150px;border-radius: 20px; background-color:white; width:300px; height:70px; opacity: 1.0;  z-index:998;text-align:center; vertical-align:middle;}
.progressBar{ z-index:999; } 
</style>
</head>

<body class="bodywrap">
<div class="waitDiv waitBox"></div>
<div class="waitDivBox waitBox">
	<br/>
	<span class="progressBar spacingN" id="progressBar"></span>
	<br/>
	<span id='loadingText'>Please Wait...</span>
</div>



<form id="dataForm" name="dataForm" >
	<div class="wrapper">
		<table border="0" cellpadding="0" cellspacing="0" class="explain_main">
		<tr>
			<td class="top">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='timWorkCount1' mdef='작업조건'/></li>
				</ul>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="default">
				<colgroup>
					<col width="150" />
					<col width="" />
				</colgroup>
                <tr>
                    <th><tit:txt mid='114399' mdef='사업장'/></th>
                    <td>
                        <select id="searchBizPlaceCd" name="searchBizPlaceCd" > </select>
                         
                    </td>
                </tr>
				<tr>
					<th><tit:txt mid='2017082900889' mdef='근무조'/></th>
					<td>
						<select id="searchWorkteamCd" name="searchWorkteamCd"> </select>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='104347' mdef='대상기간'/></th>
					<td>
						<input id="searchSym" name="searchSym" type="text" size="10" class="date2 required text-left" value="<%= DateUtil.getCurrentTime("yyyy-MM")%>"/> ~
						<input id="searchEym" name="searchEym" type="text" size="10" class="date2 required text-left" value="<%= DateUtil.getCurrentTime("yyyy-MM")%>"/>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='2017082900895' mdef='생성여부'/></th>
					<td>
						<input id="creYn" name="creYn" type="checkbox" class="checkbox" disabled/>
					</td>
				</tr>
				<tr>
					<th>사번</th>
					<td>
						<input id="searchSabun" name="searchSabun" type="text" class="text readonly" readonly/>
						<input id="name"        name="name"        type="text" class="text readonly" readonly/><a href="javascript:showEmployeePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						<a onclick="$('#searchSabun,#name').val('');" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
					</td>
				</tr>


				</table>
				<div class="h10"></div>
				<p class="center">
					<a href="javascript:doAction1('Cre');" class="btn filled large" >1.근무스케쥴 생성</a>
					<a href="javascript:doAction1('Cre2');" class="btn filled large" >2.근무이력 갱신</a>
				</p>
				<div class="h10"></div><div class="h10"></div>
				<p class="center">
					<span id="span_msg"></span>
				</p>
			</td>
		</tr>
		</table>
	</div>
</form>
</body>
</html>