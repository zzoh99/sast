<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tit" tagdir="/WEB-INF/tags/title" %>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<style type="text/css">
table.alertTable {
	width:100%;
	border-bottom:1px solid #dae1e6;
	font-weight:normal;
	text-align:left;
}
table.alertTable th{
	border-bottom:1px solid #dae1e6;
	height:30px;
	font-size:13px;
	font-weight:bolder;
	margin: 5 3 5 3;
}
table.alertTable th.nodata{
	border-bottom:1px solid #dae1e6;
	height:150px;
	font-size:16px;
	font-weight:bolder;
	text-align: center;
}
table.alertTable td{
	margin: 5 3 5 3;
}
table.alertTable th.readY{
	background: #fff;
	padding-left: 10px;
}
table.alertTable th.readN{
	border-top-left-radius: 20px;
	font-weight:bold;
	background: #f9fcfe;
	padding-left: 10px;
	cursor: pointer;
}
</style>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>알림 조회</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

//	알림 리스트 조회
function doActionAlertInfo() {
	var tb = $("#alertInfoTable tbody").html("");
	$.ajax({
		url :"${ctx}/getAlertInfoList.do",
		dateType : "json",
		type:"post",
		data: {},
		success: function( data ) {
			if(data){
				var list = data.DATA;
				if(list.length == 0){
					$('<tr><th class="nodata">새로운 알림이 없습니다</th></tr>').appendTo(tb);
				} else {
					for(var i = 0 ; i < list.length;i++){
						var ob = list[i];
						var tr = "<tr>"
						       + "<th class='"+ (ob["readYn"]=="Y"?"readY":"readN")+"'><div title=\""+ob["nTitle"]+"\"> "+ob["nTitle"]+"</div></th>"
						       + "</tr>";

						$(tr).appendTo(tb);
					};
					tb.find("tr").each(function(idx,ob){
						$(this).on("click",function(){
							alertInfoSheetOnClick.apply(this,[list[idx],idx]);
						});
					});
				}
			}
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}
//알림 리스트 클릭시 이벤트
/*
function alertInfoSheetOnClick(rowData,row) {
	if(rowData["readYn"]!="Y"){
		$.ajax({
			url :"${ctx}/updateAlertInfoReadYn.do",
			dateType : "json",
			type:"post",
			data: {seq:rowData["seq"]},
			success: function( data ) {
				if(data.Message !=""){
					alert(data.Message);
				}else{
					$("#alertInfoTable tbody tr:eq("+row+") th").removeClass("readN").addClass("readY");
					rowData["readYn"] = "Y";
				}
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	};
	var tempOb = $("#divAlertInfoResult");

	tempOb.find("div[name=nTitle]").html(rowData["nTitle"]||"").attr("title",rowData["nTitle"]||"");
	tempOb.find("div[name=nContent]").html(rowData["nContent"]||"");

	showDivAlertInfo("result");
}
*/

//알림 리스트 클릭시 이벤트
function alertInfoSheetOnClick(rowData,row) {
	selectedAlertSeq = rowData["seq"];
	selectedAlertLink = rowData["nLink"];
	
	if (selectedAlertLink) { $("#notiLink").show(); }
	else { $("#notiLink").hide(); }
	
	if (rowData["readYn"] !== "Y") {
		$.ajax({
			url :"${ctx}/updateAlertInfoReadYn.do",
			dateType : "json",
			type:"post",
			data: {seq:rowData["seq"]},
			success: function( data ) {
				if (data.Message !== "") {
					alert(data.Message);
				}else{
					$("#alertInfoTable tbody tr:eq("+row+") th").removeClass("readN").addClass("readY");
					rowData["readYn"] = "Y";
				}
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	}
	var tempOb = $("#divAlertInfoResult");
	
	tempOb.find("div[name=nTitle]").html(rowData["nTitle"]||"").attr("title",rowData["nTitle"]||"");
	tempOb.find("div[name=nContent]").html(rowData["nContent"]||"");
	
	showDivAlertInfo("result");
}

// 알림 링크 바로가기
function goDirectRecentAlert(link, seq) {
	openPopup(link,"",900,600);
	
	if (seq !== undefined && seq !== null) {
		readRecentAlert(seq);
	}
}

function deleteAllAlert(seq) {
	$.ajax({
		url :"${ctx}/deleteAllAlert.do",
		dateType : "json",
		type:"post",
		data: {seq:seq},
		success: function( data ) {
			if (data.Message !== "") {
				alert(data.Message);
			}else{
				doActionAlertInfo();
				showDivAlertInfo();
			}
		},
		error:function(e){
			alert(e.responseText);
		}
	});
}

//알림 결과창 뷰전환
function showDivAlertInfo(p){
	if(p=="result"){
		$("#divAlertInfo").hide();
		$("#divAlertInfoResult").show("slide",{direction:"right"},500);
	} else {
		$("#divAlertInfoResult").hide();
		$("#divAlertInfo").show("slide",{direction:"left"},500);
	}
}
</script>
</head>
<body class="bodywrap" style="margin:20px 20px 0px 20px">
	<div class="wrapper">
		<div>
			<div id="divAlertInfo" style="height:300px;overflow: auto;">
				<table class="alertTable" id="alertInfoTable">
					<tbody>
					</tbody>
				</table>
			</div>
			<div style="text-align:right; padding-top:8px;">
				<a id="btnDellAllAlert" href="javascript:deleteAllAlert('all')" class="btn_popW pointer">알림 모두 지우기</a>
			</div>
			<div id="divAlertInfoResult" style="display:none;height:300px;overflow: auto;">
				<table class="alertTable">
					<tbody>
						<tr>
							<th><div name="nTitle" /></th>
						</tr>
						<tr>
							<td style="vertical-align: top;"><div name="nContent" style="height:200px;overflow: auto;"/></td>
						</tr>
					</tbody>
				</table>
				<p style="text-align:center;font-size:16px;margin-top: 10px;">
					<a id="notiLink" href="javascript:goDirectRecentAlert(selectedAlertLink, selectedAlertSeq)" class="btn_popW pointer">바로가기</a>
					<a href="javascript:deleteAllAlert(selectedAlertSeq)" class="btn_popW pointer">지우기</a>
					<a href="javascript:showDivAlertInfo();"><img src="/common/images/common/btn_left_close.gif" style="vertical-align:middle;"/>알림목록으로</a>
				</p>
			</div>
		</div>
	</div>
</body>
</html>
