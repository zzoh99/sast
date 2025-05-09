<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(async function() {
		await init();
		doAction1("Search");
	});

	async function init() {
		await setBusinessPlaceCds();
		addEvents();
	}

	async function setBusinessPlaceCds() {
		const data = await callFetch("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getBusinessPlaceCdList");
		if (data == null || data.isError) {
			if (data && data.isError) alert(data.errMsg);
			else alert('알 수 없는 오류가 발생하였습니다.');
			$("#searchBusinessPlaceCd").html("");
			return;
		}

		let selectOption = '';
		if ("${ssnSearchType}" === "A") {
			selectOption = "${ssnLocaleCd}" !== "en_US" ? "전체" : "All";
		}
		const businessPlaceCds = convCode(data.codeList, selectOption);
		$("#searchBusinessPlaceCd").html(businessPlaceCds[2]);
	}

	function addEvents() {
		$("#searchYm").datepicker2({
			ymonly: true,
			onReturn: function(date) {
				$("#searchYm").val(date);
				doAction1("Search");
			}
		});

		$("#searchYm").on("keyup", function(event) {
			if( event.keyCode == 13 ) {
				doAction1("Search");
			}
		});

		$("#searchYm").blur(function() {
			doAction1("Search");
		});

		$("#searchBusinessPlaceCd").bind("change", function() {
			doAction1("Search");
		});
	}


	//Action
	async function doAction1(sAction) {

		if ($("#searchYm").val() == "") {
			alert("<msg:txt mid='alertYmdCheck' mdef='대상년월을 입력하여 주십시오.'/>");
			return;
		}

		if (sAction === "Search") {

			const data = await callFetch("${ctx}/WtmMonthlyCount.do?cmd=getWtmMonthlyCountStatus", "searchYm="+$("#searchYm").val().replace(/-/gi,"")+"&searchBusinessPlaceCd="+$("#searchBusinessPlaceCd").val());
			if (data == null || data.isError || (data.Message != null && data.Message != "")) {
				if (data == null || data.isError) {
					if (data && data.errMsg) alert(data.errMsg);
					else alert("알 수 없는 오류가 발생하였습니다.");
				} else if(data.Message != null && data.Message != "") {
					alert(data.Message);
				}

				$("#sumYn").attr("checked",false);
				$("#endYn").attr("checked",false);

				$("#btnAppCancel").hide();
				$("#btnClose").hide();
				$("#btnCloseCancel").hide();
				$("#btnApp").hide();
				return;
			}

			const sumYn = data.DATA.sumYn;
			const endYn = data.DATA.endYn;
			setSearchConditions(sumYn, endYn);
		} else if (sAction === "App") {

			if(!confirm("<msg:txt mid='confirmBatchV1' mdef='작업 하시겠습니까?'/>")) return ;

			const param = "searchYm="+$("#searchYm").val().replace(/-/gi,"") + "&sabun="+$("#sabun").val() + "&placeCd="+$("#searchBusinessPlaceCd").val();

			// 진행상태 팝업 OPEN
			openProcessBar();

			const data = await callFetch("${ctx}/WtmMonthlyCount.do?cmd=excWtmMonthlyCount", param);
			if (data == null || data.isError) {
				if (data && data.errMsg) alert(data.errMsg);
				else alert("알 수 없는 오류가 발생하였습니다.");
				return;
			}

			if (data.Result && data.Result.Code == "1") {
				alertTimer("<msg:txt mid='110120' mdef='처리되었습니다.'/>", 1000, globalWindowPopup, function(){
					window.top.windowClose();
				});
			} else {
				alert(data.Result.Message);
				// alertTimer(data.Result.Message, 1000);
			}
		} else if (sAction === "AppCancel") {

			if(!confirm("<msg:txt mid='confirmBatchV2' mdef='작업취소 하시겠습니까?'/>")) return ;

			const param = "searchYm="+$("#searchYm").val().replace(/-/gi,"") + "&sabun="+$("#sabun").val() + "&placeCd="+$("#searchBusinessPlaceCd").val();

			// 진행상태 팝업 OPEN
			openProcessBar();

			const data = await callFetch("${ctx}/WtmMonthlyCount.do?cmd=excWtmMonthlyCountCancel", param);
			if (data == null || data.isError) {
				if (data && data.errMsg) alert(data.errMsg);
				else alert("알 수 없는 오류가 발생하였습니다.");
				return;
			}

			if (data.Result && data.Result.Code == "1") {
				alertTimer("<msg:txt mid='110120' mdef='처리되었습니다.'/>", 1000, globalWindowPopup, function(){
					window.top.windowClose();
				});
			} else {
				alertTimer(data.Result.Message, 1000);
			}
		} else if (sAction === "Close") {
			if(!confirm("<msg:txt mid='confirmBatchV3' mdef='마감 하시겠습니까?'/>")) return;

			const param = "searchYm="+$("#searchYm").val().replace(/-/gi,"")
					+"&sabun="+$("#sabun").val();

			const data = await callFetch("${ctx}/WtmMonthlyCount.do?cmd=updateWtmMonthlyCountClose", param);
			if (data == null || data.isError) {
				if (data && data.errMsg) alert(data.errMsg);
				else alert("알 수 없는 오류가 발생하였습니다.");
				return;
			}

			if(data.Result) {
				alert(data.Result.Message);
				if (data.Result.Code > 0) {
					doAction1("Search");
				}
			}
		} else if (sAction === "CloseCancel") {
			if(!confirm("<msg:txt mid='confirmBatchV4' mdef='마감취소 하시겠습니까?'/>")) return;

			const param = "searchYm="+$("#searchYm").val().replace(/-/gi,"")
						+"&sabun="+$("#sabun").val();

			const data = await callFetch("${ctx}/WtmMonthlyCount.do?cmd=updateWtmMonthlyCountCloseCancel", param);
			if (data == null || data.isError) {
				if (data && data.errMsg) alert(data.errMsg);
				else alert("알 수 없는 오류가 발생하였습니다.");
				return;
			}

			if(data.Result) {
				alert(data.Result.Message);
				if (data.Result.Code > 0) {
					doAction1("Search");
				}
			}
		}
	}

	function setSearchConditions(sumYn, endYn) {
		if (sumYn === 'Y') {
			$("#sumYn").attr("checked", true);
		} else {
			$("#sumYn").attr("checked", false);
		}

		if (endYn === 'Y') {
			$("#endYn").attr("checked", true);
		} else {
			$("#endYn").attr("checked", false);
		}

		if(sumYn === 'Y' && endYn === 'Y') {
			$("#btnApp").hide();
			$("#btnAppCancel").hide();
			$("#btnClose").hide();
			$("#btnCloseCancel").show();
		}
		if(sumYn === 'Y' && endYn === 'N') {
			$("#btnAppCancel").hide();
			$("#btnCloseCancel").hide();
			$("#btnAppCancel").show();
			$("#btnClose").show();
			$("#btnApp").hide();
		}
		if(sumYn === 'N' && endYn === 'N') {
			$("#btnAppCancel").hide();
			$("#btnClose").hide();
			$("#btnCloseCancel").hide();
			$("#btnApp").show();
		}
	}

	// 작업 프로그램 진행현황 팝업
	function openProcessBar() {

		if(!isPopup()) {return;}
		gPRow = "";
		pGubun = "ProcessBarPopup";

		var args    = new Array();
		args["searchWorkGubun"] = "B";
		args["searchBusinessPlaceCd"] = $("#searchBusinessPlaceCd").val();
		args["schYm"]	= $("#searchYm").val();

		let layerModal = new window.top.document.LayerModal({
			id : 'timProcessBarLayer'
			, url : '/Popup.do?cmd=viewTimProcessBarLayer&authPg=R'
			, parameters : args
			, width : 470
			, height : 350
			, title : '진행상태'
			, trigger :[
				{
					name : 'timProcessBarLayerTrigger'
					, callback : function(result){
						doAction1("Search");
					}
				}
			]
		});
		layerModal.show();

	}


	// 초기화
	function clearCode() {
		$('#name').val("");
		$('#sabun').val("");
	}

	// 사원 팝업
	function showEmployeePopup() {
		if(!isPopup()) {return;}
		gPRow = "";
		pGubun = "employeePopup";

        let layerModal = new window.top.document.LayerModal({
            id : 'employeeLayer'
            , url : '/Popup.do?cmd=viewEmployeeLayer&authPg=R'
            , parameters : ""
            , width : 740
            , height : 520
            , title : '사원조회'
            , trigger :[
                {
                    name : 'employeeTrigger'
                    , callback : function(result){
                        $('#name').val(result.name);
                        $('#sabun').val(result.sabun);
                    }
                }
            ]
        });
        layerModal.show();
	}
</script>
</head>

<body class="bodywrap">
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
					<th><tit:txt mid='114444' mdef='대상년월'/></th>
					<td>
						<input id="searchYm" name="searchYm" type="text" size="10" class="date2 required" value="<%= DateUtil.getCurrentTime("yyyy-MM")%>"/>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='114399' mdef='사업장'/></th>
					<td>
					<select id="searchBusinessPlaceCd" name="searchBusinessPlaceCd">
					</select>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='2017083000993' mdef='월근태 집계여부'/></th>
					<td>
						<input id="sumYn" name="sumYn" type="checkbox" class="checkbox" disabled/>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='2017083000994' mdef='마감여부'/></th>
					<td>
						<input id="endYn" name="endYn" type="checkbox" class="checkbox" disabled/>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="center">
						<input id="name" name="name" type="text" class="text readonly" readonly/>
						<input id="sabun" name="sabun" type="hidden" class="text"/>
						<a href="javascript:showEmployeePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						<a href="javascript:clearCode();" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
					</td>
				</tr>
				</table>
				<div class="center" style="margin-top: 10px">
					<btn:a href="javascript:doAction1('App');" css="btn filled" id="btnApp" style="display:none;" mid='appliedV3' mdef="작업"/>
					<btn:a href="javascript:doAction1('AppCancel');" css="btn soft" id="btnAppCancel" style="display:none;" mid='appliedV4' mdef="작업취소"/>
					<btn:a href="javascript:doAction1('Close');" css="btn filled" id="btnClose" style="display:none;" mid='appClose' mdef="마감"/>
					<btn:a href="javascript:doAction1('CloseCancel');" css="btn outline" id="btnCloseCancel" style="display:none;" mid='appCloseV1' mdef="마감취소"/>
				</div>
			</td>
		</tr>
		<tr>
			<td class="bottom">
			<div class="explain">
				<div class="title"><tit:txt mid='timWorkCount2' mdef='설명'/></div>
				<div class="txt">
				<ul>
					<li><tit:txt mid='2017083000995' mdef='1. 근태마감관리는 일일 근태사항을 토대로 대상연월에 발생한 모든 근태사항을 월별로 집계하여 처리합니다.'/></li>
					<li><tit:txt mid='2017083000996' mdef='2. 작업 버튼을 클릭하면 조건연월에 대한 근태집계작업을 수행하고, 마감 버튼을 클릭하면 해당월의 근태집계내역을 확정합니다.'/></li>
				</ul>
				</div>
			</div>
			</td>
		</tr>
		</table>
	</div>
</body>
</html>