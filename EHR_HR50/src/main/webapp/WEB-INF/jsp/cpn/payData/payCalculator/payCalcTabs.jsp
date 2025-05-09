<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> 
<html class="hidden">
<head> 
<title>급여계산</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
	<link rel="stylesheet" type="text/css" href="/common/css/${wfont}.css">
	<link rel="stylesheet" type="text/css" href="/common/${theme}/css/style.css">
	<link rel="stylesheet" type="text/css" href="/common/css/common.css" />
	<link rel="stylesheet" type="text/css" href="/common/css/util.css" />
	<link rel="stylesheet" type="text/css" href="/common/css/override.css" />
	
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
	
	<script src="${ctx}/assets/plugins/apexcharts-3.42.0/apexcharts.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/common/js/common.js" type="text/javascript" charset="UTF-8"></script>
	<script src="${ctx}/assets/js/util.js" type="text/javascript" charset="UTF-8"></script>
	<script type="text/javascript" charset="UTF-8">
		//payAction 정보
		var payAction = JSON.parse('${payAction}');
		var basic = JSON.parse('${basic}');
		var locale = '${ssnLocaleCd}';
		var ctx = "${ctx}";
		var noColTy = "${sNoTy}", delColTy = "${sDelTy}", stColTy = "${sSttTy}", noColHdn = Number("${sNoHdn}"), noColWdt = "${sNoWdt}", delColWdt = "${sDelWdt}", stColWdt = "${sSttWdt}";
		var exEditable = "${editable}";
		var authPg = "${authPg}";
	</script>
	<script src="${ctx}/assets/js/salary.js?t=<%= DateUtil.getCurrentTime("yyyyMMddHHmmss") %>" type="text/javascript" charset="UTF-8"></script>
	<style>
		.salary_calculation_wrap .sheet_top_area {
			display: block;
		}

		.salary_calculation_wrap .sheet_top_area button {
			float: left;
		}

		.salary_calculation_wrap .sheet_top_area .btn_desc {
			float: right;
		}
		.salary_calculation_wrap .sheet_top_area .btn_desc.ml-auto {
			margin-left: auto;
		}
	</style>
</head>
<body class="iframe_content white">
	<form id="basicForm" name="basicForm">
		<input type="hidden" id="payActionCd" name="payActionCd" />
		<input type="hidden" id="closeYn" name="closeYn" />
	</form>
	<div>
		<header class="header full outer">
			<div class="inner">
				<div id="payTab" class="wizard_wrap">
					<span id="contentTitle" class="title_text">급여계산</span>
					<div class="wizard_box">
						<a href="#" class="wizard_btn">
							<span>1</span>
							<div>
								<b>급여목록</b><br />
								<p id="payActionDay"></p>
							</div>
						</a>
						<i class="mdi-ico">keyboard_arrow_right</i>
						<a href="#" class="wizard_btn active" >
							<span>2</span>
							<div>
								<b>급여계산</b><br/>
								<p id="payActionTarget"></p>
							</div>
						</a>
						<i class="mdi-ico">keyboard_arrow_right</i>
						<a href="#" class="wizard_btn">
							<span>3</span>
							<div><b>급여이체자료생성</b><br/><p></p></div>
						</a>
					</div>
				</div>
			</div>
		</header>
		<main id="payCalcContents" class="main_tab_content bg_gray white salary_calculation_wrap">
			<section class="top_area">
	          <div class="tab_wrap">
	            <div class="tab_menu target_create active" >대상자생성</div>
	            <div class="tab_menu data_aggregate">자료집계</div>
	            <div class="tab_menu exception_handling">수당예외처리</div>
	            <div class="tab_menu calculation">급여계산</div>
	          </div>
	          <!-- 급여계산의 상단버튼 -->
          	  <button id="calcEndBtn" class="btn filled icon_text" style="display: none;" onclick="calcAction('Close')">
	             <i class="mdi-ico">done_all</i>마감
	          </button>
	          <!-- 마감 상태일 경우 마감 취소 버튼 노출 -->
	          <button id="calcEndCancelBtn" class="btn filled icon_text" style="display: none;" onclick="calcAction('CancelClose')">
	             <i class="mdi-ico">remove_done</i>마감취소
	          </button>
	          
	        </section>
	        <!-- #target_create_content -->
	        <section class="sheet_section target_create_content" id="target_create_content">
	        	<form id="targetForm" name="targetForm">
	          		<table class="basic type5 no_border salary">
			            <tbody>
			              <tr>
			                <th>
			                  사업장
			                </th>
			                <td>
			                  <select class="custom_select" id="targetBusinessPlaceCd" name="targetBusinessPlaceCd">
			                  	<option value="">전체</option>
			                  	<c:forEach items="${orgCds}" var="code">
			                  		<option value="<c:out value="${code.code}"/>">
			                  			<c:out value="${code.codeNm}" />
			                  		</option>
			                    </c:forEach>
			                  </select>
			                </td>
			                <th>
			                  사번/성명
			                </th>
			                <td>
			                  <input class="form-input" type="text" id="targetName" name="targetName" placeholder="사번 또는 성명 입력">
			                  <button type="button" class="btn dark search_btn" onClick="targetAction('Search')">조회</button>
			                </td>
			              </tr>
			            </tbody>
			          </table>
	          	</form>
	          <div class="sheet_top_area">
	            <div class="targeted_desc">
	              <button type="button" class="btn dark" onClick="targetAction('PrcP_CPN_CAL_EMP_INS')">대상자 생성</button>
	              <p>대상자 생성&nbsp;&nbsp;<strong id="targetSheetCount">0</strong>명</p>
	              <div class="ml-auto btn_desc">
		              <button type="Button" class="btn outline_gray" onClick="targetAction('Down2Excel')">엑셀 다운로드</button>
		              <button type="Button" class="btn outline_gray" onClick="targetAction('LoadExcel')">업로드</button>
		              <button type="Button" class="btn outline_gray" onClick="targetAction('DownTemplate')">양식 다운로드</button>
		              <div class="custom_select no_style" id="targetAddBtn">
		                <button type="Button" class="btn outline_gray">추가</button>
		                <div class="select_options fix_width">
		                  <div class="option" onclick="targetAction('Insert')"><i class="mdi-ico filled">person_add_alt_1</i>1인 추가</div>
		                  <div class="option" onclick="openTargetAddModal()"><i class="mdi-ico filled">group_add</i>다수 추가</div>
		                </div>
		              </div>
		              <button class="btn filled icon_text" onClick="targetAction('Save')">
		                <i class="mdi-ico">check</i>저장
		              </button>
		            </div>
	            </div>
	          </div>
	          <div class="sheet_area">
	          	<script type="text/javascript">createIBSheet("targetSheet", "100%", "74%","kr"); </script>
	          </div>
	        </section>
	        
	        <!-- 자료집계 -->
	        <section class="sheet_section data_aggregate_content" id="data_aggregate_content">
	          <table class="basic type5 no_border salary">
	            <tbody>
	              <tr>
	                <th>
	                  사업장
	                </th>
	                <td>
	                  <select class="custom_select" id="dataBusinessPlaceCd" name="dataBusinessPlaceCd">
	                  	<option value="">전체</option>
	                  	<c:forEach items="${orgCds}" var="code">
	                  		<option value="<c:out value="${code.code}"/>">
	                  			<c:out value="${code.codeNm}" />
	                  		</option>
	                    </c:forEach>
	                  </select>
	                </td>
	                <th>
	                </th>
	                <td>              
	                <button type="button" class="btn dark search_btn" onClick="dataAction('Search')">조회</button>
	                </td>
	              </tr>
	            </tbody>
	          </table>
	          <div class="sheet_top_area">
	            <div class="btn_desc">
	              <button type="button" class="btn outline_gray" onclick="dataAction('Down2Excel')">다운로드</button>
	              <button type="button" class="btn outline_blue" onclick="dataAction('PrcP_BEN_PAY_DATA_CREATE_ALL')">작업</button>
	            </div>
	          </div>
	          <div class="sheet_area">
	          	<script type="text/javascript">createIBSheet("dataSheet", "100%", "74%", "kr"); </script>
	          </div>
	        </section>
	        
	        <!-- 수당예외처리 -->
	        <section class="sheet_section exception_handling_content" id="exception_handling_content">
	          <form id="exForm" name="exForm">
		          <table class="basic type5 no_border salary">
		            <tbody>
		              <tr>
		                <th>
		                  항목명
		                </th>
		                <td class="reflesh_btn_td">
		                  <div class="search_input">
		                    <input
		                      id="exElementNm"
		                      name="exElementNm"
		                      class="form-input"
		                      type="text"
		                    />
		                    <i class="mdi-ico" onclick="openPayElementPopup()">search</i>
		                  </div>
		                  <button type="button" class="btn outline_gray icon" onclick="$('#exElementNm').val('');">
		                    <i class="mdi-ico">refresh</i>
		                  </button>
		                </td>
		                <th>
		                  성명
		                </th>
		                <td>              
		                  <input class="form-input" id="exName" name="exName" type="text" placeholder="성명 입력">
		                  <button type="button" class="btn dark search_btn" onclick="exMAction('Search')">조회</button>
		                </td>
		              </tr>
		            </tbody>
		          </table>
	          </form>
	          <div class="content_wrap">
	            <div class="sheet_wrap ">
	              <div class="sheet_top_area">
	                <span class="title">예외관리 마스터</span>
	                <div class="btn_desc">
	                  <button type="button" class="btn outline_gray" onclick="exMAction('Copy')">복사</button>
	                  <button type="button" class="btn outline_gray" onclick="exMAction('Insert')">입력</button>
	                  <button type="button" class="btn filled" onclick="exMAction('Save')">저장</button>
	                </div>
	              </div>
	              <div class="sheet_area">
	              	<script type="text/javascript"> createIBSheet("exMSheet", "100%", "74%"); </script>
	              </div>
	            </div>
	            <div class="sheet_wrap right">
	              <div class="sheet_top_area left">
	                <span class="title">예외관리 상세</span>
	                <div class="btn_desc">
	                  <!-- <button class="btn outline_gray" onclick="openDeductionItemsModal()" >수당/공제 항목 모달 열기</button> -->
	                  <button type="button" class="btn outline_gray" onclick="exDAction('DownTemplate')">양식 다운로드</button>
	                  <button type="button" class="btn outline_gray" onclick="exDAction('Insert')">입력</button>
	                  <button type="button" class="btn outline_gray" onclick="exDAction('Copy')">복사</button>
	                  <button type="button" class="btn outline_gray" onclick="exDAction('LoadExcel')">업로드</button>
	                  <button type="button" class="btn outline_gray" onclick="exDAction('Down2Excel')">다운로드</button>
	                  <button type="button" class="btn filled" onclick="exDAction('Save')">저장</button>
	                </div>
	              </div>
	              <div class="sheet_area">
	              	<script type="text/javascript"> createIBSheet("exDSheet", "100%", "74%"); </script>
	              </div>
	            </div>
	          </div>
	        </section>
	        
	        <!-- 급여계산 -->
	        <section class="sheet_section calculation_content" id="calculation_content">
	          <form id="calcForm" name="calcForm">
				<table class="basic type5 no_border salary">
		            <tbody>
		              <tr>
		                <th>
		                  사업장
		                </th>
		                <td>
		                  <select class="custom_select" id="calcBusinessPlaceCd" name="calcBusinessPlaceCd">
		                  	<option value="">전체</option>
		                  	<c:forEach items="${orgCds}" var="code">
		                  		<option value="<c:out value="${code.code}"/>">
		                  			<c:out value="${code.codeNm}" />
		                  		</option>
		                    </c:forEach>
		                  </select>
		                </td>
		                <th>
		                  사번/성명
		                </th>
		                <td>              
		                  	<input class="form-input" type="text" id="calcName" name="calcName" placeholder="사번 또는 성명 입력">
		                	<button type="button" class="btn dark search_btn" onclick="calcAction('Search')">조회</button>
		                </td>
		              </tr>
		            </tbody>
				</table>
	          </form>
	          <div class="sheet_top_area">
	            <button id="calcBtn" type="button" class="btn filled icon_text" onclick="calcAction('PrcP_CPN_CAL_PAY_MAIN')">
	              <i class="mdi-ico">done_all</i>급여계산
	            </button>
	            <button id="calcCancelBtn" type="button" class="btn filled icon_text" onclick="calcAction('PrcP_CPN_CAL_PAY_CANCEL')">
	              <i class="mdi-ico">remove_done</i>급여계산취소
	            </button>
	            <button id="calcSummaryBtn" type="button" class="btn outline_blue" onclick="openCalCompleteModal()">요약</button>
	            <div class="btn_desc">
	              <span>*선택된 인원만 재계산이 가능합니다.</span>
	              <button type="button" class="btn outline_blue" onclick="calcAction('Recalc')">재계산</button>
	            </div>
	          </div>
	          <div class="sheet_area">
	          	<script type="text/javascript">createIBSheet("calcSheet", "100%", "73%","kr"); </script>
	          </div>
	        </section>
		</main>
		<main id="payDataCreateContents" class="main_tab_content bg_gray white salary_transfer_data_create_wrap"  style="display: none;">
			<section class="sheet_section">
		        <div class="header">
		          <h3 class="table_title">급여이체자료 생성</h3>
		        </div>
		        <table class="basic type5 no_border">
		          <tbody>
		            <tr>
		              <th>
		                사업장
		              </th>
		              <td>
		                <!-- 개발 시 참조 : select, input width가 짧은 경우 .narrow, 중간의 경우 .middle 클래스 사용 -->
		                <select class="custom_select" id="transBusinessPlaceCd" name="transBusinessPlaceCd">
		                  	<option value="">전체</option>
		                  	<c:forEach items="${orgCds}" var="code">
		                  		<option value="<c:out value="${code.code}"/>">
		                  			<c:out value="${code.codeNm}" />
		                  		</option>
		                    </c:forEach>
			            </select>
		              </td>
		              <th>
		                사번/성명
		              </th>
		              <td class="name">
		                <input class="form-input" type="text" id="transName" name="transName" placeholder="사번 또는 성명 입력">
		                <button type="button" class="btn dark check" onclick="transAction('Search')">조회</button>
		              </td>
		            </tr>
		          </tbody>
		        </table>
		        <div class="sheet_top_area">
		          <!-- 
		          <button type="button" class="btn dark check">이체자료 생성</button>
		           -->
		          <span class="btn_wrap">
		            <button type="button" class="btn outline_gray" onclick="transAction('Down2Excel')">다운로드</button>
		          </span>
		        </div>
		        <div class="sheet_area">
		        	<script type="text/javascript">createIBSheet("transSheet", "100%", "75%","kr"); </script>
		        </div>
		      </section>
		</main>
	</div>
</body>
</html>
