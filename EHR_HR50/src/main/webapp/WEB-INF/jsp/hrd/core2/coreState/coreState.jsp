<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<style type="text/css">
	#coreStatsDiv {
		overflow-x: hidden;
		overflow-y: auto;
	}
	
	#coreStatsTable td { padding: 10px 10px 2px 10px; }
	#coreStatsTable .coreEmpList { width: 100%; }
	#coreStatsTable .coreEmpList .coreEmp {
		float: left;
		display: flex;
		justify-content: start;
		align-items: center;
		min-width: 250px;
		width: calc(20% - 8px);
		margin: 0 8px 8px 0;
		border-radius: 6px;
		background-color: #f6f6f6;
		padding: 8px 0;
	}
	#coreStatsTable .coreEmpList .coreEmp:last-child { margin-right: 0px; }
	#coreStatsTable .coreEmpList .coreEmp .profile_photo { width: 64px; height: 64px; margin-left: 15px; }
	#coreStatsTable .coreEmpList .coreEmp .profile_photo img { width: 64px; }
	#coreStatsTable .coreEmpList .coreEmp .profile_info { width: calc(100% - 110px); margin-left: 15px; margin-right: 15px;}
	#coreStatsTable .coreEmpList .coreEmp .profile_info p { color: #676767; font-size: 11px; }
	#coreStatsTable .coreEmpList .coreEmp .profile_info p strong { margin-right: 10px; color: #343434; }
</style>
<script type="text/javascript">
	// 부모 iframe 높이값 계산
	var parentHeight = function() {
		var _height = 0;
		$(".ui-tabs-panel", parent.document).each(function(idx, item){
			if( $(item).css("display") != "none" ) {
				_height = $("iframe", item).outerHeight();
				return false;
			}
		});
		return _height;
	};
	
	$(function() {

		$("#searchStdYmd").datepicker2({
			onReturn: function() {
				doAction1("Search");
			}
		});
		$("#searchBizPlaceCd").on("change", function(e) {
			// 부서 콤보 박스 초기화
			initSearchOrgCd();
		});
		$("#searchOrgCd").on("change", function(e) {
			doAction1("Search");
		});
		$("#searchStdYmd, #searchSabunName").on("keyup", function(event) {
			if(event.keyCode == 13) {
				doAction1("Search");
			}
		});

		
		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		var bizPlaceCdList = "";
		var params = "queryId=getBusinessPlaceCdList";
		if("${ssnSearchType}" != "A") {
			params += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", params, false).codeList, "");	//사업장
		} else {
			bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", params, false).codeList, "전체");	//사업장
		}
		$("#searchBizPlaceCd").html(bizPlaceCdList[2]);
		$("#searchBizPlaceCd").trigger("change");
		
		setTimeout(function() {
			doAction1("Search");
			doResizeHeight();
			$(window).resize(doResizeHeight);
		}, 200);
	});
	
	// 부서 콤보 세팅
	function initSearchOrgCd() {
		var params = "queryId=getOrgCdListGrp";
		var orgCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", params + "&" + $("#srchFrm").serialize(), false).codeList, "전체");

		console.log(params);
		console.log(orgCd);

		$("#searchOrgCd").html(orgCd[2]);
	}
	
	async function doAction1(sAction) {
		switch (sAction) {		
			case "Search":
				
				progressBar(true);
				
				const data0 = ajaxCall( "${ctx}/CoreState.do?cmd=getCoreStateCnt", $("#srchFrm").serialize(), false);
				if ( data0 && data0.DATA ) {
					$("#coreCnt").text(data0.DATA.coreCnt);
					$("#corePer").text(data0.DATA.corePer);
				} else {
					$("#coreCnt").text("");
					$("#corePer").text("");
				}
				
				const data1 = ajaxCall( "${ctx}/CoreState.do?cmd=getCoreStateOrgList", $("#srchFrm").serialize(), false);
				const data2 = ajaxCall( "${ctx}/CoreState.do?cmd=getCoreStatsOrgMemberList", $("#srchFrm").serialize(), false);
				
				// 초기화
				$("#coreStatsTable").empty();
				
				var trEle, thEle, tdEle;
				if( data1 && data1 != null && data1.DATA && data1.DATA != null && data1.DATA.length > 0 ) {
					data1.DATA.forEach(function(item, idx, arr){
						trEle = $("<tr/>"), thEle = $("<th/>"), tdEle = $("<td/>");
						trEle.attr("id", "org_" + item.orgCd);
						trEle.append(thEle.append(item.orgNm + "<br/>(" + item.cnt + "명)"));
						trEle.append(
							tdEle.append(
								$("<ul/>", {
									"class" : "coreEmpList"
								})
							)
						);
						$("#coreStatsTable").append(trEle);
					});

					if( data2 && data2 != null && data2.DATA && data2.DATA != null && data2.DATA.length > 0 ) {
						var ulEle, liEle, imgEle;
						data2.DATA.forEach(function(item, idx, arr){
							ulEle = $("ul.coreEmpList", "#org_" + item.orgCd);
							liEle = $("<li/>", {
								"class" : "coreEmp"
							});
							imgEle = $("<div/>", {
								"class" : "profile_photo"
							});
							liEle.append(imgEle.append(
								$("<img/>", {
									"src" : "/EmpPhotoOut.do?enterCd=" + item.enterCd + "&searchKeyword=" + item.sabun + "&t=" + (new Date()).getTime()
								})
							));
							liEle.append(
								$("<div/>", {
									"class" : "profile_info"
								})
							);

							$(".profile_info", liEle).append($("<p/>", {"class" : "f_point"}).html(item.name + " (" + item.orgNm + ")"));
							$(".profile_info", liEle).append($("<p/>").html("<strong>사번</strong>" + item.sabun));
							$(".profile_info", liEle).append($("<p/>").html("<strong>직급</strong>" + item.jikgubNm));

							ulEle.append(liEle);
						});
					}
				} else {
					trEle = $("<tr/>");
					tdEle = $("<td/>", {
						"colspan" : "2",
						"class" : "h50 alignC"
					}).html("조회된 데이터가 없습니다.");
					$("#coreStatsTable").append(trEle.append(tdEle));
				}
				
				progressBar(false);
				break;
		}
	}
	
	// 브라우저에 따른 특정 영역의 높이를 구한다.
	function doResizeHeight() {
		// 화면 높이 계산
		var contentHeight = parentHeight() - getOuterHeight() - 45;
		$("#coreStatsDiv").css("height", contentHeight + "px");
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>기준일자</span>
							<input type="text" id="searchStdYmd" name="searchStdYmd" class="text" value="${curSysYyyyMMddHyphen}"/>
						</td>
						<td> 
							<span>소속 </span> 
							<select id="searchBizPlaceCd" name="searchBizPlaceCd"> </select> 
						</td>
						<td>
							<span>부서</span>
							<select id="searchOrgCd" name="searchOrgCd" class="box"></select>
							<input id="searchOrgType" name="searchOrgType" type="checkbox" class="checkbox mal5" value="Y" checked/> 하위포함
						</td>
						<td>
							<span>사번/성명</span>
							<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
						</td>
						<td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='search' mdef="조회"/> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt">
					핵심인재현황 : 총 <span id="coreCnt"></span>명 (총원의 <span id="corePer"></span>%)
				</li>
			</ul>
		</div>
	</div>
	<div id="coreStatsDiv">
		<table border="0" cellpadding="0" cellspacing="0" class="default">
			<colgroup>
				<col width="150px" />
				<col width="*" />
			</colgroup>
			<tbody id="coreStatsTable"></tbody>
		</table>
	</div>
</div>
</body>
</html>