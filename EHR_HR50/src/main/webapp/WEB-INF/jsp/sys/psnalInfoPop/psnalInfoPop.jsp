<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='114397' mdef='인사기본팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var arg = p.window.dialogArguments;
	var searchUserId = arg["sabun"];
	var enterCd = arg["enterCd"];
	var ssnEnterCd = "${ssnEnterCd}";
	
	
	var mainMenuCd = arg["mainMenuCd"];
	var grpCd      = arg["grpCd"];
	var menuCd     = arg["menuCd"];
	
	
	var dbLink = "";
	
	if(ssnEnterCd == "PTCH") {
// 		if(enterCd != "PTCH") {
// 			dbLink = "@DB_123";
// 		}
	} else {
// 		if(enterCd == "PTCH") {
// 			dbLink = "@DB_192";
// 		}
	}
	
	$(function() {
		$("#searchUserId").val(searchUserId);
		$("#searchEnterCd").val(enterCd);
		$("#searchDbLink").val(dbLink);
		
		var user = ajaxCall("/PsnalInfoPop.do?cmd=getPsnalInfoPopEmployeeDetail",$("#empForm").serialize(),false);
		if(user.map != null && user.map != "undefine") user = user.map;
	
		$("#searchKeyword" ).val(user.name);
		$("#tdSabun"       ).html(user.sabun);
		$("#tdManageNm"    ).html(user.manageNm);
		$("#tdStatusCd"    ).val(user.statusCd);  //삭제대상 => headStatusCd 로 대체 
		$("#tdStatusNm"    ).html(user.statusNm);
		$("#tdWorkTypeNm"  ).html(user.workTypeNm);
		$("#tdJikweeNm"    ).html(user.jikweeNm);
		$("#tdJikhakNm"    ).html(user.jikchakNm);
		$("#tdLocationNm"  ).html(user.locationNm);
		$("#tdGempYmd"     ).html(user.gempYmd);
		$("#tdEmpYmd"      ).html(user.empYmd);
		$("#tdRetYmd"      ).html(user.retYmd);
		$("#tdJobNm"       ).html(user.jobNm);
		$("#tdOrgPath"     ).html(user.orgPath);
		
		//add Info .. addPlz 
		$("#headJikweeCd"  ).val(user.jikweeCd);
		$("#headJikweeNm"  ).val(user.jikweeNm);
		$("#headStatusCd"  ).val(user.statusCd);
		$("#headStatusNm"  ).val(user.statusNm);
		$("#headJobCd"     ).val(user.jobCd);
		$("#headJobNm"     ).val(user.jobNm);
		$("#headOrgCd"     ).val(user.orgCd);
		$("#headOrgNm"     ).val(user.orgNm);
	
		if (typeof $("#tdRmidYmd").html() != "undefined") {
			$("#tdRmidYmd").html(user.rmidYmd);
		}
		if (typeof $("#tdYearYmd").html() != "undefined") {
			$("#tdYearYmd").html(user.yearYmd);
		}
		
		userSabun = user.sabun;
		enterCd  = user.enterCd;
		
		$("#userFace").attr("src","/EmpPhotoOut.do?enterCd="+enterCd+"&searchKeyword="+userSabun);
		
        $(".close").click(function() {
	    	p.self.close();
	    });
	});
	
	var cmTabObj;
	var cmTabData;
	var cmTabNewIframe;
	var cmTabOldIframe;
	var cmTabIframeIdx;
	
	$(function() {
		
		cmTabObj = $( ".insa_tab #tabs" ).tabs({
			beforeActivate: function(event, ui) {
				cmTabIframeIdx = ui.newTab.index();
				cmTabNewIframe = $(ui.newPanel).find('iframe');
				cmTabOldIframe = $(ui.oldPanel).find('iframe');
				showCommonTab(cmTabIframeIdx);
			}
		});
		
		createCmTabData();
		
		// 화면 리사이즈
		$(window).resize(setIframeHeight);
		setIframeHeight();
	});
	
	//탭 높이 변경
	function setIframeHeight() {
		var iframeTop = $("#tabs ul.tab_bottom").height() + 16;
		$(".layout_tabs").each(function() {
			$(this).css("top",iframeTop);
		});
	}	
	
	// 탭 생성
	function createCmTabData() {
		var param = "mainMenuCd="+mainMenuCd
			  		+ "&grpCd="+grpCd
			  		+ "&menuCd="+menuCd
			  		+ "&dbLink="+dbLink
			  		+ "&enterCd="+ssnEnterCd;
		
		cmTabData = ajaxCall("/PsnalInfoPop.do?cmd=getPsnalInfoPopTabInfoList", param,false);
	
		if(cmTabData.Message == "") {
			$(cmTabData.DATA).each(function(index) {
				cmTabObj.find(".ui-tabs-nav").append("<li><a href='#tabs-"+index+"'>"+this.menuNm+"</a></li>");
			});
	
			$(cmTabData.DATA).each(function(index) {
				cmTabObj.append("<div id='tabs-"+index+"'><div class='layout_tabs' style='height:380px;'><iframe id='iframe-"+index+"' name='iframe-"+index+"' src='${ctx}/common/hidden.html' frameborder='0' class='tab_iframes'></iframe></div></div>");
			});
	
			cmTabObj.tabs( "refresh" );
			cmTabObj.tabs( "option", "active", 0 );
	
		} else {
			alert(cmTabData.Message);
		}
	}
	
	// iframe 호출.
	function showCommonTab(index) {
		if(typeof cmTabOldIframe != 'undefined') {
			cmTabOldIframe.attr("src","${ctx}/common/hidden.html");
		}
		
		if(typeof index != 'undefined') {
			if(cmTabIframeIdx == index) {
				var obj = cmTabData.DATA[cmTabIframeIdx];
				$("#dataPrgType").val("R");
				$("#dataRwType").val("R");
				$("#enterCd").val(enterCd);
				$("#dbLink").val(dbLink);
				$("#sabun").val(searchUserId);
	
				$("#cmTabForm").attr("action",obj.prgCd)
								.attr("method","post")
								.attr("target",cmTabNewIframe.attr("id"))
								.submit();
			} else {
				cmTabObj.tabs( "option", "active", index );
			}
		} else {
			var obj = cmTabData.DATA[cmTabIframeIdx];
			$("#dataPrgType").val("R");
			$("#dataRwType").val("R");
			$("#enterCd").val(enterCd);
			$("#dbLink").val(dbLink);
			$("#sabun").val(searchUserId);
	
			$("#cmTabForm").attr("action",obj.prgCd)
							.attr("method","post")
							.attr("target",cmTabNewIframe.attr("id"))
							.submit();
		}
	}	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	    <ul>
	        <li><tit:txt mid='114398' mdef='임직원 상세정보'/></li>
	        <li class="close"></li>
	    </ul>
	</div>

	<div class="popup_main" style="margin:15px 15px 0;">
	<table border="0" cellpadding="0" cellspacing="0" class="default outer" >
	<colgroup>
		<col width="" />
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
		<td rowspan="4" class="photo"><img src="/common/images/common/img_photo.gif" id="userFace" width="80" height="101" /></td>
		<th><tit:txt mid='103880' mdef='성명'/></th>
		<td><form id="empForm" name="empForm" >
			<input type="text"   id="searchKeyword"  name="searchKeyword" class="text transparent" style="ime-mode:active" readonly/>
			<input type="hidden" id="searchEmpType"  name="searchEmpType" value="I"/> <!-- Include에서  사용 -->
			<input type="hidden" id="searchStatusCd" name="searchStatusCd" value="A" /><!-- in ret -->
			<input type="hidden" id="searchUserId"   name="searchUserId" value="" />
			<input type="hidden" id="searchEnterCd"  name="searchEnterCd" value="" />
			<input type="hidden" id="searchDbLink"   name="searchDbLink" value="" />
			</form>
		</td>
		<th><tit:txt mid='103975' mdef='사번'/></th>
		<td>
			<span id="tdSabun"></span>
			<input type=hidden id="headName"> 
		</td>
		<th><tit:txt mid='103784' mdef='사원구분'/></th>
		<td id="tdManageNm"></td>
		<th><tit:txt mid='104472' mdef='재직상태'/></th>
		<td>
			<span id="tdStatusNm"></span>
			<input type=hidden id="tdStatusCd">  
			<input type=hidden id="headStatusCd">
			<input type=hidden id="headStatusNm">
		</td>
	</tr>
	<tr>
		<th><tit:txt mid='104089' mdef='직군'/></th>
		<td id="tdWorkTypeNm"></td>
		<th><tit:txt mid='104104' mdef='직위'/></th>
		<td>
			<span id="tdJikweeNm"></span>
			<input type=hidden id="headJikweeNm">
			<input type=hidden id="headJikweeCd">
		</td>
		<th><tit:txt mid='103785' mdef='직책'/></th>
		<td id="tdJikhakNm"></td> 
		<th><tit:txt mid='104281' mdef='근무지'/></th>
		<td id="tdLocationNm"></td>
	</tr>
	<tr>
		<th><tit:txt mid='104473' mdef='그룹입사일'/></th>
		<td id="tdGempYmd"></td>
		<th><tit:txt mid='103881' mdef='입사일'/></th>
		<td id="tdEmpYmd"></td>
		<th><tit:txt mid='104369' mdef='퇴직일'/></th>
		<td id="tdRetYmd"></td>
		<th><tit:txt mid='103973' mdef='직무'/></th>
		<td>
			<span id="tdJobNm"></span>
			<input type=hidden id="headJobCd">
			<input type=hidden id="headJobNm">
		</td>
	</tr>
	<tr>
		<th><tit:txt mid='112962' mdef='소속경로'/></th>
		<td colspan="7">
			<span id="tdOrgPath"></span>
			<input type=hidden id="headOrgNm">
			<input type=hidden id="headOrgCd">
		</td>
	</tr>
	</table>
	</div>
	
	<!-- 공통탭 -->
	<form id="cmTabForm" name="cmTabForm" action="" method="post">
		<input id="dataPrgType" name="dataPrgType" type="hidden" />
		<input id="dataRwType" name="dataRwType" type="hidden" />
		<input id="enterCd" name="enterCd" type="hidden" />
		<input id="dbLink" name="dbLink" type="hidden" />
		<input id="sabun" name="sabun" type="hidden" />
		<input id="authPg" name="authPg" type="hidden" value="R" />
	</form>

	<div class="insa_tab" style="margin-top:55px; height:380px;">
		<div id="tabs" class="tab" style='height:380px; position:relative; margin-left:15px; margin-right:15px;'>
			<ul  class="tab_bottom"></ul>
		</div>
	</div>
		
	<div class="popup_button" style="margin-top:400px;">
	    <ul>
	        <li>
	            <btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
	        </li>
	    </ul>
	</div>
</div>
</body>
</html>
