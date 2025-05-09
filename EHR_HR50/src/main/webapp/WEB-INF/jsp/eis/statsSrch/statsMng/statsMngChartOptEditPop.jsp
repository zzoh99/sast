<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>요구사항 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<style type="text/css">
	.editPresetInfo {
		z-index: 10;
		position: fixed;
		top: 10px;
		right: 50px;
		display: inline-block;
		min-width: 40px;
		text-align: center;
		background-color: #fff;
		height: 28px;
		line-height: 26px;
		border-radius: 14px;
		padding: 0 15px;
	}
	textarea.edit {
		width: 100%;
		font-family: 'Consolas';
		font-size: 15px;
		tab-size: 4;
		-moz-tab-size: 4;
		background: #2e2e2e;
		color: #d6d6d6;
		scrollbar-width: thin;
		line-height: 1.2em;
	}
</style>
<script type="text/javascript">
	var p = eval("${popUpStatus}");

	$(function() {

		$("textarea.edit").keydown(function(event){
			// 탭키 누른 경우 탭 입력 처리
			if(event.keyCode == 9){
				var v=this.value,s=this.selectionStart,e=this.selectionEnd;
				this.value=v.substring(0, s)+'\t'+v.substring(e);
				this.selectionStart=this.selectionEnd=s+1;
				return false;
			}
		});
		
		$(".close").click(function(){
			p.self.close();
		});
		
		var arg     = p.window.dialogArguments;
		var searchStatsCd = "";
		var searchStatsNm = "";
		
		if( arg != undefined ) {
			searchStatsCd = arg["searchStatsCd"];
			searchStatsNm = arg["searchStatsNm"];
		}else{
			if ( p.popDialogArgument("searchStatsCd") !=null ) { 	searchStatsCd = p.popDialogArgument("searchStatsCd"); }
			if ( p.popDialogArgument("searchStatsNm") !=null ) { 	searchStatsNm = p.popDialogArgument("searchStatsNm"); }
		}

		$("#searchStatsCd").val(searchStatsCd);
		$("#searchStatsNm").val(searchStatsNm);
		
		// 현재작업통계구성명 삽입
		$(".editPresetInfo").html($("<span/>", {
			"class" : ""
		}).text("작업 통계 : "));
		$(".editPresetInfo").append($("<span/>", {
			"class" : "f_point f_bold"
		}).text(searchStatsNm));
		
		// set event
		$("#chartOpt").maxbyte(4000);
		
		var data = ajaxCall("${ctx}/StatsMng.do?cmd=getStatsMngChartOptMap",$("#sendForm").serialize(),false);
		if( data && data != null && data.DATA && data.DATA != null ) {
			$("#chartOpt").val(data.DATA.chartOpt);
		} else {
			$("#chartOpt").val("{}");
		}
		
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Save":
				if(!checkList()) return ;
				if (confirm( "저장하시겠습니까?")) {
					try{
						var rtn = ajaxCall("${ctx}/StatsMng.do?cmd=saveStatsMngChartOpt",$("#sendForm").serialize(),false);
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
			<li id="locationPopup">차트 옵션 설정</li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="editPresetInfo"></div>
	<div class="popup_main">
		<form id="sendForm" name="sendForm" method="POST">
			<input type="hidden" id="searchStatsCd" name="searchStatsCd" value="" />
			<input type="hidden" id="searchStatsNm" name="searchStatsNm" value="" />
			<p class="mab10"><strong>JSON</strong></p>
			<textarea id="chartOpt" name="chartOpt" class="required edit" rows="40" cols="10" wrap="off"></textarea>
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