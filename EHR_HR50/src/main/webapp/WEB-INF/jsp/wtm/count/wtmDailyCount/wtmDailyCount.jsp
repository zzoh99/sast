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

	$(function() {

		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만 .
		var url     = "queryId=getBusinessPlaceCdList";
		var allFlag = false; //전체 사업장으로 처리 안되도록 처리!
		if ("${ssnSearchType}" != "A"){
			allFlag = false;
		}
		var businessPlaceCd = "";
		if(allFlag) {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "전체" : "All"));	//사업장
		} else {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
		}

		$("#searchBpCd").html(businessPlaceCd[2]);

		$("#sdate").datepicker2({
			startdate:"edate"
		});

		$("#edate").datepicker2({
			enddate:"sdate"
		});

		$("#sdate, #edate").bind("keyup", function(event) {
			if( event.keyCode == 13 ) {
				doAction1("Search");
			}
		});

		$("#searchBpCd").bind("change", function(event) {
			doAction1("Search");
		}) ;

		//TODO 테스트를 위해 임시로 버튼 활성화 함.
		$("#btnApp").show();
		$("#btnAppCancel").show();
		// doAction1("Search");
	});

	//Action
	function doAction1(sAction) {
		var confirmMsg = "" ;
		sAction == "App" ? confirmMsg = "<msg:txt mid='confirmBatchV1' mdef='작업 하시겠습니까?'/>" : "" ;
		sAction == "AppCancel" ? confirmMsg = "<msg:txt mid='confirmBatchV2' mdef='작업취소 하시겠습니까?'/>" : "" ;
		sAction == "Close" ? confirmMsg = "<msg:txt mid='confirmBatchV3' mdef='마감 하시겠습니까?'/>" : "" ;
		sAction == "CloseCancel" ? confirmMsg = "<msg:txt mid='confirmBatchV4' mdef='마감취소 하시겠습니까?'/>" : "" ;
		switch (sAction) {
		case "Search":

			if($("#sdate").val() === "" || $("#edate").val() === "") {
				alert("<msg:txt mid='alertYmdCheck' mdef='대상일자을 입력하여 주십시오.'/>");
				return;
			}


			var data = ajaxCall("${ctx}/WtmDailyCount.do?cmd=getWtmDailyCount", $("#wtmDailyCountFrm").serialize(), false);

			if(data != null && data.DATA != null) {
				(data.DATA.sumYn == 'Y')?$("#sumYn").attr("checked",true):$("#sumYn").attr("checked",false);
				(data.DATA.endYn == 'Y')?$("#endYn").attr("checked",true):$("#endYn").attr("checked",false);

				if(data.DATA.sumYn == 'Y' && data.DATA.endYn == 'Y') {
					$("#btnApp").hide();
					$("#btnAppCancel").hide();
					$("#btnClose").hide();
					$("#btnCloseCancel").show();
				}
				if(data.DATA.sumYn == 'Y' && data.DATA.endYn == 'N') {
					$("#btnAppCancel").hide();
					$("#btnCloseCancel").hide();
					$("#btnAppCancel").show();
					$("#btnClose").show();
					$("#btnApp").hide();
				}
				if(data.DATA.sumYn == 'N' && data.DATA.endYn == 'N') {
					$("#btnAppCancel").hide();
					$("#btnClose").hide();
					$("#btnCloseCancel").hide();
					$("#btnApp").show();
				}

			} else {
				if(data.Message != null && data.Message != "") {
					alert(data.Message);
				}
				$("#sumYn").attr("checked",false);
				$("#endYn").attr("checked",false);

				$("#btnAppCancel").hide();
				$("#btnClose").hide();
				$("#btnCloseCancel").hide();
				$("#btnApp").hide();
			}

			break;
		case "App":
			if($("#sdate").val() === "" || $("#edate").val() === "") {
				alert("<msg:txt mid='alertYmdCheck' mdef='대상일자을 입력하여 주십시오.'/>");
				return;
			}

			if(!confirm(confirmMsg)) {
				return ;
			}

			$.ajax({
				url : "${ctx}/WtmDailyCount.do?cmd=prcWtmDailyCount",
				type : "post",
				dataType : "json",
				async : true,
				data : $("#wtmDailyCountFrm").serialize(),
				success : function(data) {

					if(data.Result != null && data.Result.Code > 1) {
						alertTimer("<msg:txt mid='110120' mdef='처리되었습니다.'/>", 1000, globalWindowPopup, function(){
							window.top.windowClose();
						});
					} else {
						alertTimer(data.Result.Message, 1000);
					}
				},
				error : function(jqXHR, ajaxSettings, thrownError) {
					ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
				}
			});
			break;

		case "AppCancel":
			if($("#sdate").val() === "" || $("#edate").val() === "") {
				alert("<msg:txt mid='alertYmdCheck' mdef='대상일자을 입력하여 주십시오.'/>");
				return;
			}

			if(!confirm(confirmMsg)) {
				return ;
			} else {

			}

			var data;
			var param = "schYm="+$("#schYm").val().replace(/-/gi,"")+"&sabun="+$("#sabun").val()+"&placeCd="+$("#searchBpCd").val();
			var sync;

			if(sAction == "App") {
				param = param + "&gubun=app";
				sync = true;
			} else {
				param = param + "&gubun=appCancel";
				sync = false;
			}

			$.ajax({
				url : "${ctx}/WtmDailyCount.do?cmd=prcWtmDailyCount",
				type : "post",
				dataType : "json",
				async : sync,
				data : param,
				success : function(data) {

					if(data.Result != null && data.Result.Code == "1") {
						alertTimer("<msg:txt mid='110120' mdef='처리되었습니다.'/>", 1000, globalWindowPopup, function(){
							window.top.windowClose();
						});
						//alertTimer("<msg:txt mid='110120' mdef='처리되었습니다.'/>", 1000);
					} else {
						alertTimer(data.Result.Message, 1000);
					}
				},
				error : function(jqXHR, ajaxSettings, thrownError) {
					ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
				}
			});

			//if(sAction == "App") {
				// 진행상태 팝업 OPEN
				openProcessBar();
			//}
			break;

		case "Close":
		case "CloseCancel":
			if($("#sdate").val() === "" || $("#edate").val() === "") {
				alert("<msg:txt mid='alertYmdCheck' mdef='대상일자을 입력하여 주십시오.'/>");
				return;
			}
			//progressBar(true) ;
			if(!confirm(confirmMsg)) {
				//progressBar(false) ;
				return ;
			}

			var param = "schYm="+$("#schYm").val().replace(/-/gi,"")
						+"&sabun="+$("#sabun").val();

			var data;
			if(sAction == "Close") {
		    	data = ajaxCall("${ctx}/WtmDailyCount.do?cmd=updateWtmDailyCountEndYn",param+"&endYn=Y&searchBpCd="+$("#searchBpCd").val(),false);
			} else {
		    	data = ajaxCall("${ctx}/WtmDailyCount.do?cmd=updateWtmDailyCountEndYn",param+"&endYn=N&searchBpCd="+$("#searchBpCd").val(),false);
			}

	    	if(data.Result != null && data.Result.Code > 0) {
	    		alert("<msg:txt mid='110120' mdef='처리되었습니다.'/>");
	    		doAction1("Search");
		    	//progressBar(false) ;
	    	} else if(data.Result != null && data.Result.Message != null){
		    	alert(data.Result.Message);
		    	//progressBar(false) ;
	    	}

			break;
		}
	}

	// 작업 프로그램 진행현황 팝업
	function openProcessBar() {

		if(!isPopup()) {return;}
		gPRow = "";
		pGubun = "ProcessBarPopup";

		var args    = new Array();

		args["searchWorkGubun"] = "B";
		args["searchBpCd"] = $("#searchBpCd").val();
		args["schYm"]	= $("#schYm").val();

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

        //var rst = openPopup("/Popup.do?cmd=employeePopup&authPg=R", "", "740","520");
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
<form id="wtmDailyCountFrm" name="wtmDailyCountFrm">
	<div class="wrapper">
		<table border="0" cellpadding="0" cellspacing="0" class="explain_main">
		<tr>
			<td class="top">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='wtmDailyCount1' mdef='작업조건'/></li>
				</ul>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="default">
				<colgroup>
					<col width="150" />
					<col width="" />
				</colgroup>
				<tr>
					<th><tit:txt mid='114444' mdef='대상일자'/></th>
					<td>
						<input id="sdate" name="sdate" type="text" size="10" class="date2" value="${curSysYyyyMMdd}"/> ~
						<input id="edate" name="edate" type="text" size="10" class="date2" value="${curSysYyyyMMdd}"/>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='114399' mdef='사업장'/></th>
					<td>
					<select id="searchBpCd" name="searchBpCd">
					</select>
					</td>
				</tr>
<%--				<tr>--%>
<%--					<th><tit:txt mid='2017083000993' mdef='월근태 집계여부'/></th>--%>
<%--					<td>--%>
<%--						<input id="sumYn" name="sumYn" type="checkbox" class="checkbox" disabled/>--%>
<%--					</td>--%>
<%--				</tr>--%>
<%--				<tr>--%>
<%--					<th><tit:txt mid='2017083000994' mdef='마감여부'/></th>--%>
<%--					<td>--%>
<%--						<input id="endYn" name="endYn" type="checkbox" class="checkbox" disabled/>--%>
<%--					</td>--%>
<%--				</tr>--%>
				<tr>
					<td colspan="2" class="center">
						<input id="name" name="name" type="text" class="text readonly" readonly/>
						<input id="sabun" name="sabun" type="hidden" class="text"/>
						<a href="javascript:showEmployeePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						<a href="javascript:clearCode();" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
					</td>
				</tr>
				</table>
				<div class="center mt-12 mb-24">
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
				<div class="title"><tit:txt mid='wtmDailyCount2' mdef='설명'/></div>
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
</form>
</body>
</html>