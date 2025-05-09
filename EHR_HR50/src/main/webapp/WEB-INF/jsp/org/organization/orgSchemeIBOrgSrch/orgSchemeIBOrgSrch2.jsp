<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%
	/************************************************************@@
	 * Program ID		: orgSchemeIBOrgSrch.jsp
	 * Program Name		: 화상조직도
	 * Description		: 화상조직도
	 * Company			: ISU System
	 * Author			: ISU
	 * Create Date		: ?
	 * History			: 2016.03.22 modified by 장태성(IBLeaders)
	 @@************************************************************/
%>
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
<!--
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/ibleaders.js?=3" type="text/javascript" charset="utf-8"></script>
 -->
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/iborginfo.js?=3" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/iborg.js?=3" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/iborg2excel.js?=3" type="text/javascript" charset="utf-8"></script>

<!-- IBOrg# 5 관련 스크립트 -->
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/lib/jquery.blockUI.js?ver=<%= System.currentTimeMillis()%>" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/module/ibconfig.js?ver=<%= System.currentTimeMillis()%>" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/module/loadObj.js?ver=<%= System.currentTimeMillis()%>" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/module/btnObj.js?ver=<%= System.currentTimeMillis()%>" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/module/nodeEditObj.js?ver=<%= System.currentTimeMillis()%>" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/module/orgObj.js?ver=<%= System.currentTimeMillis()%>" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/module/sheetObj.js?ver=<%= System.currentTimeMillis()%>" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript" src="/common/js/cookie.js"></script>

<script type="text/javascript">
	var myOrg;
	var sdate = "";
	var baseURL = "${baseURL}";
	var ssnSabun = "${ssnSabun}";
	var ssnLocaleCd = "${ssnLocaleCd}";
	var searchType = "";
	
	// 화상조직도 기본 설정값 중 baseUrl 설정 
	orgObj.valiable.baseUrl = "${baseURL}";

	$(function() {
		var rtn = null;
		$("#ibContent").hide();
		// var applCdList	= convCodeIdx( ajaxCall("${ctx}/OrgSchemeIBOrgSrch.do?cmd=getOrgSchemeIBOrgSrchApplCdList","",false).codeList, "<tit:txt mid='103895' mdef='전체'/>",-1);
// 		$(window).smartresize(sheetResize); sheetInit();

		//조직도 select box
		var searchSdate = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgSchemeSdate",false).codeList, "");	//조직도
		$("#searchSdate").html(searchSdate[2]);

		//조직원을 가져올 때 과거 / 미래 조직도에 따라 Sdate를 넣을지 Sysdate를 넣을지 구분하기 위하여 Edate도 불러온다. by JSG
		var searchEdate = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgSchemeEdate",false).codeList, "");	//조직도종료일
		$("#searchEdate").html(searchEdate[2]);

		/*
		$( "#baseDate" ).datepicker2({
			startdate : "baseDateHiddenAfter",
			enddate   : "baseDateHiddenBefore"
		});
*/
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

		$("#inputFindName").on("keyup", function(event) {
			if( event.keyCode == 13) {
				sheetObj.findName();
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
			doAction("Org");
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

	///////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////

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
		var url = "${ctx}/OrgSchemeIBOrgSrch.do?cmd=getOrgSchemeIBOrgSrchList";

		// 조회중 표시를 위한 Block 영역 생성
		// 조직도 코드에서 조회 완료 후, 사라지게 처리함.
		loadObj.showBlockUI();

		switch (sAction) {

		case "Org":
			// 조직도 데이터 삭제
			orgObj.ClearData();

			// 트리 데이터 삭제
			mySheet.RemoveAll();

			// 디자인 타입 확인
			setTreeType();
			
			if( $("#treeType").val() == "PhotoBox2" || $("#treeType").val() == "PhotoList" ) {
				$("#boxCompare").show();
			} else {
				$("#boxCompare").hide();
			}

			// 트리로 조직 데이터 조회
			// 트리(시트)에서 조회 완료 후, 조직도 모듈에서 데이터를 생성하게 처리함.
			mySheet.DoSearch(url, $("#orgForm").serialize());
			break;
		}
    }
/*
	//기준일 변경입력시
	function setSearchSdate(baseDate){
		var searchBaseDate = baseDate.replaceAll("-","");
		if(searchBaseDate.length == 8){
			OrgSchemeIBOrg1_list_ifrmsrc2.location.href = "/JSP/org/organization/OrgSchemeIBOrg1_list_ifrmsrc2.jsp?"
					+"searchBaseDate="+searchBaseDate;
		}
	}
	//기준일 변경입력시 콜백
	function setSearchSdateBack(maxSdate){
		document.all.searchSdate.value = maxSdate;
		//doAction("search1");
	}
*/

/*
function myOrg_OnNodeDoubleClick(sender, args) {
	//alert(args.NodeID + "가 클릭되었습니다.");
	//arr[0] 조직코드, arr[1] 사번

	 if($('#name1').val() == ""){
         $('#name1').val(myOrg.GetNodeDBData(args.NodeID, "EMPNM"));
         $('#sabun1').val(myOrg.GetNodeDBData(args.NodeID, "EMPCD"));
     }else if($('#name2').val() == ""){
         $('#name2').val(myOrg.GetNodeDBData(args.NodeID, "EMPNM"));
         $('#sabun2').val(myOrg.GetNodeDBData(args.NodeID, "EMPCD"));
     }else if($('#name3').val() == ""){
         $('#name3').val(myOrg.GetNodeDBData(args.NodeID, "EMPNM"));
         $('#sabun3').val(myOrg.GetNodeDBData(args.NodeID, "EMPCD"));
     }else{
         alert("<msg:txt mid='110062' mdef='비교대상 등록이 완료 되었습니다.'/>");
     }

	} */

//비교대상 초기화
function clearCode(num) {
  switch(num) {
  case "name1" :

      $('#name1').val("");
      $('#sabun1').val("");
      break ;
  case "name2" :
      $('#name2').val("");
      $('#sabun2').val("");
      break ;
  case "name3" :
      $('#name3').val("");
      $('#sabun3').val("");
      break ;
  }
}

//비교대상 화면으로 이동
function goMenu() {

    //비교대상 정보 쿠키에 담아 관리
	setCookie("CompareEmpN1",$('#name1').val(),1000);
	setCookie("CompareEmpS1",$('#sabun1').val(),1000);
	setCookie("CompareEmpN2",$('#name2').val(),1000);
    setCookie("CompareEmpS2",$('#sabun2').val(),1000);
    setCookie("CompareEmpN3",$('#name3').val(),1000);
    setCookie("CompareEmpS3",$('#sabun3').val(),1000);

    var prgCd = "CompareEmp.do?cmd=viewCompareEmp";

    $("#prgCd").val(prgCd);
	var prgData = ajaxCall("${ctx}/OrgPersonSta.do?cmd=getCompareEmpOpenPrgMap",$("#orgForm").serialize(),false);

	if(prgData.map == null) {
		alert("<msg:txt mid='109611' mdef='권한이 없거나 존재하지 않는 메뉴입니다.'/>");
		return;
	}

	if(typeof goSubPage == 'undefined') {
		// 서브페이지에서 서브페이지 호출
		if(typeof window.top.goOtherSubPage == 'function') {
			window.top.goOtherSubPage("", "", "", "", "CompareEmp.do?cmd=viewCompareEmp");
		}
	} else {
		goSubPage("", "", "", "", "CompareEmp.do?cmd=viewCompareEmp");
	}

}

function setUseLevel(){
	
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
							<th>조직도</th>
							<td>
								<select id="searchSdate" name ="searchSdate" class="w250"></select>
								<span class="hide"><select id="searchEdate" name ="searchEdate"></select></span>
							</td>
							<th><tit:txt mid='113921' mdef='종류'/></th>
							<td>
								<select id="treeType" name="treeType">
			                    	<option value="HeadPhotoBox">조직+헤드사진</option>
			                    	<option value="Org">조직</option>
			                        <option value="PhotoBox">조직+사진</option>
			                        <option value="PhotoBox2">조직+직원</option>
			                        <option value="PhotoList">조직+사진+직원</option>
			                    </select>
			                </td>
<!-- 			                <td> -->
<!-- 			          			<label> -->
<!-- 			          				<span><tit:txt mid='112848' mdef='레벨정렬'/></span> -->
<!-- 			                    	<input id="treeLevel" name="treeLevel" type="checkbox" checked/> -->
<!-- 			                    </label> -->
<!-- 			                </td> -->
		                    <th>정렬</th>
			                <td>
								<select id="treeAlign" name="treeAlign">
			                    	<option value='true'>형태1</option>
			                        <option value='3'>형태2</option>
			                    </select>
			                </td>
	          				<th><tit:txt mid='112501' mdef='트리보기'/></th>
			                <td>
		                    	<input id="treeShow" name="treeShow" type="checkbox" />
			                </td>
			                <td>
								<btn:a href="javascript:doAction('Org')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/>
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
	          				<th><tit:txt mid='112502' mdef='폰트'/></th>
			                <td>
		                    	<select id="fontName" name="fontName">
									<option value="Dotum">돋움</option>
									<option value="NanumGothic">나눔고딕</option>
								</select>
			                </td>
						</tr>
						<tr id="boxCompare" style="display:none;">
							<td colspan="7">
	                            <span class="w50"><b>비교대상</b></span>
	                            <input id="name1" name="name1" type="text" class="text  readonly" readonly/>
	                            <input id="sabun1" name="sabun1" type="hidden" class="text"/>
	                            <a href="javascript:clearCode('name1')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
	                            &nbsp;&nbsp;
	                            <input id="name2" name="name2" type="text" class="text  readonly" readonly/>
	                            <input id="sabun2" name="sabun2" type="hidden" class="text"/>
	                            <a href="javascript:clearCode('name2')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
	                            &nbsp;&nbsp;
	                            <input id="name3" name="name3" type="text" class="text  readonly" readonly/>
	                            <input id="sabun3" name="sabun3" type="hidden" class="text"/>
	                            <a href="javascript:clearCode('name3')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
	                            &nbsp;&nbsp;
	                           <btn:a href="javascript: goMenu()"     css="btn filled authR" mid='110785' mdef="비교"/>
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
			<div id="ibContent" style="position:absolute; left:1px; top:100px; width:260px; height:'calc(100% - 100px)'/*90%*/; bottom:0px; border:1px solid silver; background-color:#fff; z-index:1000;">
				<label for="treeShow" class="floatR" style="margin:2px 7px 0 0;"><img src="${ ctx }/common/images/common/btn_delete.gif" /></label>
			    <ul class="tabs">
			       	<li class="active" rel="tab1"><tit:txt mid='114658' mdef='트리'/></li>
			       	<li rel="tab2"><tit:txt mid='112170' mdef='정보'/></li>
			    </ul>
			    <div class="tab_container" style="width:260px;">
					<div id="tab1" class="tab_content">
						<div style="position:absolute; top:36px; left:1px; width:260px;">
							<select id="selFindType">
								<option value="deptnm">부서명</option>
								<option value="empnm">이름</option>
							</select>
							<input id="inputFindName" style="font-size:13px;" size=8 />
							<btn:a href="javascript:sheetObj.findName()" id="btnFindName" css="btn dark" mid='110799' mdef="검색"/>
						</div>

			  			<div id="sheetDiv" style="position:absolute; top:66px;left:2px; width:260px; height:100%;"></div>
			  		</div>
			  		<div id="tab2" class="tab_content">
			  			<div id="editPanelArea" style="position:absolute; top:36px;left:2px; width:250px; height:100%;"></div>
			  		</div>
			  	</div>
			</div>
			<div id="orgDiv" style="position:absolute; top:80px; left:1px; right:0px; bottom:0px; height:90%;"></div>
			<!-- 화상 조직도 오른쪽 상단 기능 버튼 -->
			<div id="Toolbar" style="position:absolute;top:113px;right:36px; z-Index:9999; padding:4px 4px 0px 4px; border-radius:4px; border: 2px solid #FFFFFF; background-color:#D3D3D3; box-shadow:4px 4px 8px #CCC;">
				<img src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/img/CAPTURE.png" id="btnImageSave" style="cursor:pointer;" />
<%-- 				<img src="${ctx}/common/plugin/IBLeaders/Org/IBOrgSharp5/img/FILEOPEN.png" id="btnFileOpen" style="cursor:pointer; margin-left:4px;" /> --%>
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
</body>
</html>




