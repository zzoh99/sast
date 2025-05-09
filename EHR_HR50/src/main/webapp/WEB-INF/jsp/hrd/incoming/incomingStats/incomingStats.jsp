<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<!-- CSS -->
<link href="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/css/style.css" rel="stylesheet">

<!-- IBOrg# 5 코어 -->
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/iborginfo.js?=3" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/iborg.js?=3" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/iborg2excel.js?=3" type="text/javascript" charset="utf-8"></script>

<!-- IBOrg# 5 관련 스크립트 -->
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/lib/jquery.blockUI.js?=3" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/module/loadObj.js?=3" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/module/btnObj.js?=3" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/module/sheetObj.js?=3" type="text/javascript" charset="utf-8"></script>

<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/module/ibconfig.js?=3" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/module/nodeEditObj.js?=3" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/module/orgObj.js?=3" type="text/javascript" charset="utf-8"></script>

<!--  <script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/module/ibconfig_incomingStats.js?=3" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/module/nodeEditObj_incomingStats.js?=3" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/module/orgObj_incomingStats.js?=3" type="text/javascript" charset="utf-8"></script> -->

<script type="text/javascript">
	var myOrg;
	var sdate = "";
	var baseURL = "${baseURL}";
	var enterCd = "${ssnEnterCd}";
	
	// 화상조직도 기본 설정값 중 baseUrl 설정 
	orgObj.valiable.baseUrl = "${baseURL}";
	
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
	}, contentHeight = 0, sheetDivHeight = 0;
	
	$(function() {
		var rtn = null;
		$("#ibContent").hide();

		//조직도 select box
		var searchSdate = convCodeCols( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgSchemeSdate",false).codeList,"memo", "");	//조직도
		$("#searchSdate").html(searchSdate[2]);

		//조직원을 가져올 때 과거 / 미래 조직도에 따라 Sdate를 넣을지 Sysdate를 넣을지 구분하기 위하여 Edate도 불러온다. by JSG
		var searchEdate = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgSchemeEdate",false).codeList, "");	//조직도종료일
		$("#searchEdate").html(searchEdate[2]);

		$("#baseDate").datepicker2();

		// 최초 loading 시 보여줄날짜 및 선택 범위 셋팅
		$("#baseDate").mask("1111-11-11");
		$("#baseDate").val( "${curSysYyyyMMddHyphen}"	);
		$("#baseDateHiddenBefore").val( dateConv( $("#searchSdate option:selected").val() )	);
		$("#baseDateHiddenAfter").val( "${curSysYyyyMMddHyphen}" );

		$("#searchSdate").change(function(){
			var baseDate		= dateConv($(this).bind("option:selected").val());

			// 달력에서 선택할수 있는 범위 설정(여기부터)
			$("#baseDateHiddenBefore").val( baseDate );

			// 달력에서 선택할수 있는 범위 설정(여기까지)
			if( $(this).find("option").index( $(this).find("option:selected") ) > 0 ){ 					// selectbox 의 선택된 option 이 첫번째가 아닐경우

				var index		= $(this).find("option").index( $(this).find("option:selected") ) - 1 ;	// 현재 selected 이전 index
				var beforeDay	= $(this).find("option:eq(" + index + ")").val() ;						// 현재 selected 이전 value
				var newdate		= new Date (	beforeDay.substr(0,4)
											,	beforeDay.substr(4,2) - 1
											,	beforeDay.substr(6,2)
										);																// date 생성

				newdate.setDate( newdate.getDate() - 1 );												// selected 이전 value 하루전

				var baseDateHiddenAfter	= dateConv(datePv(newdate) );									// yyyymmdd 로 변환 후 yyyy-mm-dd 로 변환

				$("#baseDateHiddenAfter").val( baseDateHiddenAfter );									// init
				// 현재 보여줄 날짜 selectbox(#searchSdate) 의 seleted 값
				$("#baseDate").val( baseDateHiddenAfter );
			} else {																					// selectbox 의 선택된 option 이 첫번째일경우
				$("#baseDateHiddenAfter").val( "${curSysYyyyMMddHyphen}" );
				// 현재 보여줄 날짜 selectbox(#searchSdate) 의 seleted 값
				$("#baseDate").val( "${curSysYyyyMMddHyphen}" );
			}
		});
		
		// 화면 높이 계산
		contentHeight = parentHeight() - getOuterHeight() - 20, sheetDivHeight = contentHeight - 40;

		// 조직도 초기화 및 생성
		btnObj.init();
		nodeEditObj.init();
		orgObj.init();
		sheetObj.init(sheetDivHeight + "px");

		$("#treeShow").click();
		
		// 조직도 초기 설정에 필요한 시간 이후 조회하도록 Timeout을 설정함.
		// 원래는 orgObj.init() 처리 후 doAction을 실행하도록 해야하지만,
		// 다른 개발자들이 기본 조회 부분을 찾기 어려울수 있어서 부득이하게 Timeout을 걸어놓음.
		setTimeout(function() {
			doAction("IncomList");
			setBodyHeight();
			$(window).resize(setBodyHeight);
		}, 200);
	});

	var datePv = function (newdate){

		var sYear	= newdate.getFullYear();
		var sMonth	= newdate.getMonth()+1;
		var sDate	= newdate.getDate();

		sMonth		= sMonth > 9 ? sMonth : "0" + sMonth;
		sDate		= sDate > 9 ? sDate : "0" + sDate;

		var date	= sYear + "" + sMonth + "" + sDate;

		return date;
	};

	var dateConv = function (date){
		var conDate = date.substr(0,4)+"-"+date.substr(4,2)+"-"+date.substr(6,2);
		return conDate;
	};

	/**
	 * 디자인 타입 확인
	 */
    function setTreeType(){
    	$("#searchType").val( $("#treeType").val() );
    	if ($("#treeType").val() == "OrgV") {
    		orgObj.init("OrgV");
    	}
    }

	/**
	 * 조회
	 * @param  {String} sAction : 조회 명령
	 */
	function doAction(sAction) {
		var url = "${ctx}/IncomingStats.do?cmd=getIncomingStatsList";

		// 조회중 표시를 위한 Block 영역 생성
		// 조직도 코드에서 조회 완료 후, 사라지게 처리함.
		loadObj.showBlockUI();

		switch (sAction) {

		case "IncomList":
			// 조직도 데이터 삭제
			orgObj.ClearData();

			// 트리 데이터 삭제
			mySheet.RemoveAll();

			// 디자인 타입 확인
			setTreeType();

			// 트리로 조직 데이터 조회
			// 트리(시트)에서 조회 완료 후, 조직도 모듈에서 데이터를 생성하게 처리함.
			mySheet.DoSearch(url, $("#orgForm").serialize());
			break;
		}
    }

	function setBodyHeight() {
		/*
		var body = getDivHeight("body");
		$("#body").css("height", body);
		$("#ibContent").css("height", body-7);
		*/
		$("#body").css("height", contentHeight + "px");
		$("#ibContent").css("height", (contentHeight - 35) + "px");
	}

</script>
</head>
<body class="bodywrap" >
	<div class="wrapper">
		<form id="orgForm" name="orgForm">
			<input id="searchOrgCd" 	name="searchOrgCd" 		type="hidden"/>
			<input id="searchType" 		name="searchType" 		type="hidden"/>
			<input id="searchOrgPath" 	name="searchOrgPath" 	type="hidden"/>
			<input id="priorOrgCd" 		name="priorOrgCd" 		type="hidden"/>
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<td colspan="4">
								<span>기준일</span>
								<input type="text" id="baseDate" name="baseDate" class="date2" value=""/>

								<span class="hide">
									<input type="text" id="baseDateHiddenBefore" name="baseDateHiddenBefore" class="date" value="" readonly="readonly"/>
									<input type="text" id="baseDateHiddenAfter" name="baseDateHiddenAfter" class="date" value="${curSysYyyyMMddHyphen}" readonly="readonly"/>
								</span>

								<span>조직도  </span><select id="searchSdate" name ="searchSdate" class="w250"></select>
								<span class="hide"><select id="searchEdate" name ="searchEdate"></select></span>
							</td>							
						</tr>
						<tr>
							<td>
								<span>종류</span>
								<select id="treeType" name="treeType" class="w100">
			                    	<option value="IncomList">후임자</option>
			                    </select>
			                </td>
			                
			                <td class="hide">
			          			<label>
			          				<span>정렬</span>
									<select id="treeAlign" name="treeAlign">
				                    	<option value='true'>형태1</option>
				                        <option value='3'>형태2</option>
				                    </select>
			                    </label>
			                </td>
			                <td>
			          			<label>
			          				<span>트리보기</span>
			                    	<input id="treeShow" name="treeShow" type="checkbox" />
			                    </label>
			                </td>
							<td>
								<select id="zoom" name="zoom">
									<option value="2.0">200%</option>
									<option value="1.5">150%</option>
									<option value="1.0" selected>100%</option>
			                    	<option value="0.9">90%</option>
			                    	<option value="0.8">80%</option>
			                    	<option value="0.7">70%</option>
			                    	<option value="0.6">60%</option>
			                    	<option value="0.5">50%</option>
			                    	<option value="0.4">40%</option>
			                    	<option value="0.3">30%</option>
			                    	<option value="0.2">20%</option>
			                    	<option value="0.1">10%</option>
			                    </select>
			                </td>
			                <td>
			          			<label>
			          				<span>폰트</span>
			                    	<select id="fontName" name="fontName">
										<option value="Dotum">돋움</option>
										<option value="NanumGothic">나눔고딕</option>
									</select>
			                    </label>
			                </td>
			                <td>
								<btn:a href="javascript:doAction('IncomList')" id="btnSearch" css="button" mid='search' mdef="조회"/>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</form>

		<div id="body">
			<div class="contents" style="padding:0;">
				<!-- 패널&탭 영역 -->
				<div id="ibContent" class="w250 bd_r4 bg_gray_e pad10" style="position:absolute; left:1px; top:96px;">
					<div id="sheetDiv"></div>
				</div>
				<div id="orgDiv" style="position:relative; height:100%;"></div>
				<!-- 화상 조직도 오른쪽 상단 기능 버튼 -->
				<div id="Toolbar" style="position:absolute;top:93px;right:36px; z-Index:9999; padding:4px 4px 4px 4px; border-radius:4px; border: 2px solid #FFFFFF; background-color:#D3D3D3; box-shadow:4px 4px 8px #CCC;">
					<img src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/img/CAPTURE.png" id="btnImageSave" style="cursor:pointer;" />
					<img src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/img/FILESAVE.png" id="btnFileSave" style="cursor:pointer; margin-left:4px;" />

					<!-- 확대 -->
					<img src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/img/ZOOM_IN.png" id="btnZoomIn" style="cursor:pointer; margin-left:4px;" />
					<!-- 축소 -->
					<img src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/img/ZOOM_OUT.png" id="btnZoomOut" style="cursor:pointer; margin-left:4px;" />
					<!-- 100% -->
					<img src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/img/ZOOM_RESET.png" id="btnZoomReset" style="cursor:pointer; margin-left:4px;" />
					<!-- Fit -->
					<img src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/img/ZOOM_FIT.png" id="btnZoomFit" style="cursor:pointer; margin-left:4px;" />
				</div>
		  	</div>
		</div>
	</div>
</body>
</html>