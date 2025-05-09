<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>평가수행</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	function setEmpPage() {
		$("#searchSabun").val($("#searchUserId").val());
		doAction1("Search");
	}
	
	$(function() {
		$("#cmbAppraisalCd").bind("change",function(event){
			$("#searchAppraisalCd").val($("#cmbAppraisalCd").val());
			makeSelfEval()
			makeOtherEval()
		});
		$("#searchSabun").val($("#searchUserId").val());
		doAction1("Search");
	})	
	

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	
			var comboData = ajaxCall("${ctx}/InternEval.do?cmd=getInternEvalComboList",$("#srchFrm").serialize(), false).DATA;
			if (comboData.length < 1) {
				$(".exception").show();
				$(".main").hide();
			} else {
				$(".exception").hide();
				$(".main").show();
				var comboList1 = convCode(comboData, "");
				$("#cmbAppraisalCd").html(comboList1[2]);
				$("#cmbAppraisalCd").change();
			}
			break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}

			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if(Row >= sheet1.HeaderRows()){
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	//사원 팝업
	function employeePopup(){
		try{
			if(!isPopup()) {return;}

			var args = new Array();

			gPRow = "";
			pGubun = "searchEmployeePopup";

			openPopup("${ctx}/Popup.do?cmd=employeePopup", args, "740","520");
		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
	}
	
	/** 본인평가 */
	function makeSelfEval() {
		var selfEvalList = ajaxCall("${ctx}/InternEval.do?cmd=getInternSelfEvalList",$("#srchFrm").serialize(), false).DATA;
		if (selfEvalList.length < 1) {
			$("#selfTopLine").hide();
			return;
		} else {
			$("#selfTopLine").show();
		}
		
		var htmlProcess = "";
		var obj = null;
		for (var index=0; index<selfEvalList.length; index++) {
			obj = selfEvalList[index];
			htmlProcess += makeContainer(obj.appStatus, obj.stepOnOff, index + 1, obj.stepNm, obj.stepMsg);
		}
		
		$(".self").get(0).innerHTML = "";
		$(".self").append(htmlProcess);
		
		$(".self>.container>div").on("click", function(e) {
			var appStatus = $(e.target.parentElement).children(".itemType").val();
			var title = $(e.target.parentElement).children(".itemNm").html();
			var src = "";
			var height = "";
			var width = "";
			var calFunc;
			var param = {
					//appTypeCd: appTypeCd,
					sabun: $("#searchSabun").val(),
					title: title,
					appraisalCd: $("#searchAppraisalCd").val(),
					appStatus: appStatus
			}
			
			title = "주간일지작성";
			src = "InternEval.do?cmd=viewInternSelfEvalDetailPopup"
			width = "80%";
			height= "80%";
			calFunc = function(){
				makeSelfEval();
			}
			
			openModalPopup(src, param, width, height
					, calFunc
			, {title:title});
		})
	}

	/** 타인평가 */
	function makeOtherEval() {
		var otherEvallist = ajaxCall("${ctx}/InternEval.do?cmd=getInternOtherEvalList",$("#srchFrm").serialize(), false).DATA;
		if (otherEvallist.length < 1) {
			$("#otherTopLine").hide();
			return;
		} else {
			$("#otherTopLine").show();
		}
		
		var htmlProcess = "";
		var obj = null;
		for (var index=0; index<otherEvallist.length; index++) {
			obj = otherEvallist[index]; 
			htmlProcess += makeContainer(obj.appStatus, obj.stepOnOff, index+1, obj.stepNm, obj.stepMsg)
		}
		
		$(".other").get(0).innerHTML = "";
		$(".other").append(htmlProcess);
		$(".other>.container>div").on("click", function(e) {
			var appStepCd =  $(e.target.parentElement).children(".itemType").val();
			var popupTitle = $(e.target.parentElement).children(".itemNm").html();
			var title = $(e.target.parentElement).children(".itemNm").html();
			var src = "InternEval.do?cmd=viewInternOtherEvalListPopup";
			var width = "60%";
			var height = "60%";
			if (appStepCd == "3") {
				title = "주간일지"; 
			} else if (appStepCd == "5") {
				title = "관찰표"; 
			} else if (appStepCd == "7") {
				title = "수습평가표";
			}
			var param = {
					appStepCd: appStepCd,
					sabun: $("#searchSabun").val(),
					title: title,
					appraisalCd: $("#searchAppraisalCd").val()
			}
			openModalPopup(src, param, width, height
					, function(){
						makeSelfEval();
						makeOtherEval();
					}
			, {title:popupTitle});
		})
	}	
	
	function makeContainer(psStepCd,psContainerClass, psIndex, psNm, psStatus) {
		psContainerClass == null ? psContainerClass : "";
		psIndex == null ? psIndex : "";
		psNm == null ? psNm : "";
		psStatus == null ? psStatus : "";
		return '<div class="container ' + psContainerClass + '">'
				+ '<input type="hidden" class="itemType" value="' + psStepCd + '"</input>'
				+ '<input type="hidden" class="itemIndex" value="' + psIndex + '"</input>'
				+ '<div class="itemStepIndex">STEP' + psIndex + '</div>'
				+ '<div class="itemNm">' + psNm + '</div>'
				+ '<div class="itemStatus"> ' + psStatus + '</div>'
				+ '</div>'
	}
	
	function openPopup(psGubun) {
		var src = "InternEval.do?cmd=viewInternGuidePopup";
		var width = "60%";
		var height = "80%";
		if (psGubun == "guide") {
			openModalPopup(src, {"appraisalCd":$("#searchAppraisalCd").val()}, width, height
					, null
			, {title:"공지사항"});	
		}
	}
	
</script>
</head>
<body class="bodywrap">
<style>
	.main {
		margin-top:0.8em;
		width:auto;
		height:100%;
	}
	
	#spanAppraisalCd {
		font-size: 1.1em;
		font-weight: bold;
	}
	
	/*조회결과가 없을시 보여주는 div*/
	.exception > .noApp {
		background:url(/common/images/common/img_noApp.gif) 0 0 no-repeat;
		height: 40px;
		padding: 7px 0 0 70px;
		font-size: 2em;
		top: 50%;
		left: 30%;
		position: absolute;
		margin: -24px 0 0 -35px;
	}
	
	/*self, app*/
	.wrap_Htable {overflow:hidden;border:0px solid #b8c6cc; display:flex; margin-top:10px;}
	.self, .other {
		display: flex;
		flex-direction: row;
		width: 100%;
		justify-content: flex-start;
	}
	div.container {
		width:140px;
		border-radius:12px;
		margin: 0px 5px;
		cursor: pointer;
	}
	
	div.container.on {
		background:#212121 url(/common/images/sub/ico_arrow_w.svg) 97% center no-repeat;
		-webkit-animation: blink 0.7s ease-in-out infinite alternate;
	  	-moz-animation: blink 0.7s ease-in-out infinite alternate;
	  	animation: blink 0.7s ease-in-out infinite alternate;
	}
	
	@-webkit-keyframes blink{
	  0% {opacity: 0.4;}
	  100% {opacity: 1;}
	}
	
	@-moz-keyframes blink{
	  0% {opacity: 0.4;}
	  100% {opacity: 1;}
	}
	
	@keyframes blink{
	  0% {opacity: 0.4;}
	  100% {opacity: 1;}
	}
	
	div.container.off {
		background:#F2F2F3 url(/common/images/sub/ico_arrow.svg) 97% center no-repeat;
	}				

	div.container:hover {
		transform: scale(1.1);
 			transition-duration: 0.5s;
 			background:#e0e2e5 url(/common/images/sub/ico_arrow2_1.png) 97% center no-repeat;
	}	
		
	div.container.on:hover {
		transform: scale(1.1);
 			transition-duration: 0.5s;
 			background:#212121 url(/common/images/sub/ico_arrow2_w.png) 97% center no-repeat;
	}
	
	div.container.on  > div.itemStepIndex {
		color:#C2C2C5;
		font-size:9px;
		text-align:left; 
		letter-spacing:-1px;
		letter-spacing:-1px;
		line-height:15px;
		/*padding:14px 20px 8px 12px;*/
		padding:5px 0 5px 12px;
	}
	
	div.container.off > div.itemStepIndex {
		color:#C2C2C5;
		font-size:9px;
		text-align:left; 
		letter-spacing:-1px;
		letter-spacing:-1px;
		line-height:15px;
		/*padding:14px 20px 8px 12px;*/
		padding:5px 0 5px 12px;
	}		
	
	div.container.on > div.itemNm {
		color:#FFFFFF;
		font-size:15px;
		font-weight:bold;
		text-align:left;
		vertical-align:middle; 
		letter-spacing:-1px;
		line-height:16px;
		/*padding:14px 20px 8px 12px;*/
		padding:10px 30px 8px 12px;
		height:32px;
	}
	
	div.container.off > div.itemNm {
		color:#212121;
		font-size:15px;
		font-weight:bold;
		text-align:left;
		vertical-align:middle; 
		letter-spacing:-1px;
		line-height:16px;
		/*padding:14px 20px 8px 12px;*/
		padding:10px 30px 8px 12px;
		height:32px;
	}		
	
	div.container.on  > div.itemStatus {
		color:#fff;
		font-size:9px;
		text-align:left; 
		letter-spacing:-1px;
		/*padding:14px 20px 8px 12px;*/
		padding:5px 20px 8px 12px;
	}
	
	div.container.off  > div.itemStatus {
		color:#212121;
		font-size:9px;
		text-align:left; 
		letter-spacing:-1px;
		/*padding:14px 20px 8px 12px;*/
		padding:5px 20px 8px 12px;
	}		
	
	.imgSelfTit {
			position:relative;width:110px; height:100px;background:#FFFFFF url(/common/images/common/img_selfTit.svg) 97% center no-repeat;border-radius:12px; margin-right:10px; margin-top: 10px;
	}
	
	.imgAppTit {
		position:relative;width:110px; height:100px;background:#FFFFFF url(/common/images/common/img_appTit.svg) 97% center no-repeat;border-radius:12px; margin-right:10px; margin-top: 10px;
	}
</style>
<div class="wrapper">
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	<form id="srchFrm" name="srchFrm" >
	<input type="hidden" id="searchAppSeqCd" name="searchAppSeqCd" value="${map.searchAppSeqCd}" />
	<input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" />
	<input type="hidden" id="searchSabun" name="searchSabun" />
	</form>
	<div class="main">
		<div class="sheet_title">
			<ul>
				<li><span id="spanAppraisalCd" class="txt">대상평가기준</span>&nbsp;&nbsp;&nbsp;<select id="cmbAppraisalCd" name="cmbAppraisalCd"></select></li>
				<li class="btn">
					<a href="javascript:openPopup('guide')" style="padding: 10px 20px;margin-right: 5px;" class="basic">공지사항조회</a>
				</li>
			</ul>
		</div>
		<div id="selfTopLine" class="wrap_Htable" hide>
			<div class="imgSelfTit"></div>
			<div class='self'></div>
		</div>
		<div id="otherTopLine" class="wrap_Htable" hide>
			<div class="imgAppTit"></div>
			<div class='other'></div>
		</div>
		</table>
	</div>
	<div class="exception" hidden>
		<p class="noApp">평가대상, 기간이 아닙니다.</p>
	</div>
	
</div>
</body>
</html>