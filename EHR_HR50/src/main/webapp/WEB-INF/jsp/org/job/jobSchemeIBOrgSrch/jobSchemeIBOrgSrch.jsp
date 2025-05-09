<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%
	/************************************************************@@
	 * Program ID		: jobSchemeIBOrgSrch.jsp
	 * Program Name		: 화상조직도 직무
	 * Description		: 화상조직도 직무
	 * Company			: ISU System
	 * Author			: ISU
	 * Create Date		: 2020.04.21 Created by 박문순
	 * History			: 
	 @@************************************************************/
	 String ver2 = "20181127_1";
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>


<!-- CSS -->
<link href="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp6/css/style.css" rel="stylesheet">

<!-- IBOrg# 5 코어 -->
<!--
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp6/ibleaders.js?=3" type="text/javascript" charset="utf-8"></script>
 -->
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp6/iborginfo.js?<%=ver2 %>" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp6/iborg.js?<%=ver2 %>" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp6/iborg2excel.js?<%=ver2 %>" type="text/javascript" charset="utf-8"></script>

<!-- IBOrg# 5 관련 스크립트 -->
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp6/lib/jquery.blockUI.js?<%=ver2 %>" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp6/module/ibconfigJob.js?<%=ver2 %>" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp6/module/loadObj.js?<%=ver2 %>" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp6/module/btnObj.js?<%=ver2 %>" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp6/module/nodeEditObj.js?<%=ver2 %>" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp6/module/orgObj.js?<%=ver2 %>" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp6/module/sheetObj.js?<%=ver2 %>" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript" src="/common/js/cookie.js"></script>

<script type="text/javascript">
	var myOrg;
	var sdate = "";
	var baseURL = "${baseURL}";

	$(function() {
		var rtn = null;

		//조직도 select box
		var searchSdate = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgSchemeSdate",false).codeList, "");	//조직도
		$("#searchSdate").html(searchSdate[2]);

		//조직원을 가져올 때 과거 / 미래 조직도에 따라 Sdate를 넣을지 Sysdate를 넣을지 구분하기 위하여 Edate도 불러온다. by JSG
		var searchEdate = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgSchemeEdate",false).codeList, "");	//조직도종료일
		$("#searchEdate").html(searchEdate[2]);

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

		// 조직도 초기화 및 생성
		btnObj.init();
		nodeEditObj.init();
		orgObj.init();
		sheetObj.init();

		// 조직도 초기 설정에 필요한 시간 이후 조회하도록 Timeout을 설정함.
		// 원래는 orgObj.init() 처리 후 doAction을 실행하도록 해야하지만,
		// 다른 개발자들이 기본 조회 부분을 찾기 어려울수 있어서 부득이하게 Timeout을 걸어놓음.
		setTimeout(function() {
			doAction("Job");
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
    }

	/**
	 * 조회
	 * @param  {String} sAction : 조회 명령
	 */
	function doAction(sAction) {
		var url = "${ctx}/JobSchemeIBOrgSrch.do?cmd=getJobSchemeIBOrgSrchList";

		// 조회중 표시를 위한 Block 영역 생성
		// 조직도 코드에서 조회 완료 후, 사라지게 처리함.
		loadObj.showBlockUI();

		switch (sAction) {

		case "Job":
			if($("#doubleYn").is(":checked")){
				$("#doubleYn").val("Y");
			}
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
</script>
</head>
<body class="bodywrap" >
	<div class="wrapper">
		<form id="orgForm" name="orgForm">
			<input id="prgCd" 	name="prgCd" 		type="hidden"/>
			<input id="searchOrgCd" 	name="searchOrgCd" 		type="hidden"/>
			<input id="searchType" 		name="searchType" 		type="hidden"/>
			<!-- <input id="searchSdate" 	name="searchSdate" 		type="hidden"/> -->
			<input id="searchOrgPath" 	name="searchOrgPath" 	type="hidden"/>
			<input id="priorOrgCd" 		name="priorOrgCd" 		type="hidden"/>
			<input id="ObjType" 		name="ObjType" 			type="hidden" value="Job"/>
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th><tit:txt mid='104535' mdef='기준일'/></th>
							<td>
								<input type="text" id="baseDate" name="baseDate" class="date" value="" readonly="readonly"/>
								<span class="hide">
									<input type="text" id="baseDateHiddenBefore" name="baseDateHiddenBefore" class="date" value="" readonly="readonly"/>
									<input type="text" id="baseDateHiddenAfter" name="baseDateHiddenAfter" class="date" value="${curSysYyyyMMddHyphen}" readonly="readonly"/>
								</span>
							</td>
							<th class="hide"><tit:txt mid='112713' mdef='조직도 '/> </th >
							<td>
								<span class="hide"><select id="searchSdate" name ="searchSdate" class="w250"></select>
								<select id="searchEdate" name ="searchEdate"></select></span>
							</td>
							<th><tit:txt mid='113921' mdef='종류'/></th>
							<td>
								<select id="treeType" name="treeType" class="w100">
			                    	<option value="Org"><tit:txt mid='jobNm' mdef='직무'/></option>
			                        <option value="PhotoBox2"><tit:txt mid='2021031600002' mdef='직무+직원'/></option>
			                    </select>
			                </td>
<!-- 			                <td> -->
<!-- 			          			<label> -->
<!-- 			          				<span>레벨정렬</span> -->
<!-- 			                    	<input id="treeLevel" name="treeLevel" type="checkbox" checked/> -->
<!-- 			                    </label> -->
<!-- 			                </td> -->
		                    <th><tit:txt mid='2017082800598' mdef='정렬'/></th>
			                <td>
								<select id="treeAlign" name="treeAlign">
			                    	<option value='true'><tit:txt mid='2017082800599' mdef='형태1'/></option>
			                        <option value='3' selected><tit:txt mid='2017082800600' mdef='형태2'/></option>
			                    </select>
			                </td>
	          				<th><tit:txt mid='112501' mdef='트리보기'/></th>
			                <td>
		                    	<input id="treeShow" name="treeShow" type="checkbox" />
			                </td>
		          			<th class="hide">겸직여부</th>
			                <td class="hide">
		                    	<input id="doubleYn" name="doubleYn" type="checkbox" />
			                </td>
			                <td>
								<btn:a href="javascript:doAction('Job')" id="btnSearch" css="btn dark" mid='search' mdef="조회"/>
							</td>
							<td colspan=5>
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
	          				<th><tit:txt mid='112502' mdef='폰트'/></th>
			                <td>
		                    	<select id="fontName" name="fontName">
									<option value="Dotum"><tit:txt mid='113570' mdef='돋움'/></option>
									<option value="NanumGothic"><tit:txt mid='112169' mdef='나눔고딕'/></option>
								</select>
			                </td>
						</tr>
					</table>
				</div>
			</div>
		</form>
	</div>

	<div id="body">
		<div class="contents">
			<!-- 패널&탭 영역 -->
			<div id="ibContent" style="position:absolute; left:-200px; top:95px; width:196px; height:90%; bottom:0px; border:0px solid silver;">
			    <ul class="tabs">
			       	<li class="active" rel="tab1"><tit:txt mid='114658' mdef='트리'/></li>
			       	<li rel="tab2" class="hide"><tit:txt mid='112170' mdef='정보'/></li>
			    </ul>
			    <div class="tab_container">
					<div id="tab1" class="tab_content">
						<div style="position:absolute; top:36px; left:1px; width:196px;">
							<select id="selFindType">
								<option value="deptnm"><tit:txt mid='113316' mdef='직무'/></option>
								<option value="empnm"><tit:txt mid='103915' mdef='이름'/></option>
							</select>
							<input id="inputFindName" style="font-size:13px;" size=8 />
							<btn:a href="javascript:sheetObj.findName()" id="btnFindName" css="btn dark" mid='searchV1' mdef="검색"/>
						</div>

						<div style="position:absolute; top:66px;left:2px; width:196px; bottom:20px;">
							<div id="sheetDiv" style="position:absolute; top:0;left:0; width:100%; height:100%;"></div>
						</div>

			  		</div>
			  		<div id="tab2" class="tab_content hide">
			  			<div id="editPanelArea" style="position:absolute; top:36px;left:2px; width:196px; height:100%;"></div>
			  		</div>
			  	</div>
			</div>
			<div id="orgDiv" style="position:absolute; top:120px; left:1px; right:0px; bottom:0;"></div>
			<!-- 화상 조직도 오른쪽 상단 기능 버튼 -->
			<div id="Toolbar" style="position:absolute;top:98px;right:36px; z-Index:9999; padding:4px 4px 0px 4px; border-radius:4px; border: 2px solid #FFFFFF; background-color:#D3D3D3; box-shadow:4px 4px 8px #CCC;">
				<img src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp6/img/CAPTURE.png" id="btnImageSave" style="cursor:pointer;" />
<%-- 				<img src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp6/img/FILEOPEN.png" id="btnFileOpen" style="cursor:pointer; margin-left:4px;" /> --%>
				<img src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp6/img/FILESAVE.png" id="btnFileSave" style="cursor:pointer; margin-left:4px;" />

				<!-- 확대 -->
				<img src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp6/img/ZOOM_IN.png" id="btnZoomIn" style="cursor:pointer; margin-left:4px;" />
				<!-- 축소 -->
				<img src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp6/img/ZOOM_OUT.png" id="btnZoomOut" style="cursor:pointer; margin-left:4px;" />
				<!-- 100% -->
				<img src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp6/img/ZOOM_RESET.png" id="btnZoomReset" style="cursor:pointer; margin-left:4px;" />
				<!-- Fit -->
				<img src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp6/img/ZOOM_FIT.png" id="btnZoomFit" style="cursor:pointer; margin-left:4px;" />
			</div>
	  	</div>
	</div>
</body>
</html>




