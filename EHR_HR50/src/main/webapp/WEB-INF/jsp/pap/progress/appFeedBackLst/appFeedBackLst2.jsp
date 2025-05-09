<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	$(function() {
	});
</script>
</head>
<body class="hidden">
	<div class="wrapper">
		<!-- include 기본정보 page TODO -->
		<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
		<form id="srchFrm" name="srchFrm" >
			<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
			<input type="hidden" id="searchName" name="searchName" value=""/>
			<!-- 호출 팝업 넘겨줄 키 값 -->
			<input type="hidden" id="exceptionSdateValue" name="exceptionSdateValue" value=""/>
			<input type="hidden" id="exceptionEdateValue" name="exceptionEdateValue" value=""/>
		</form>
		<!-- <div class="sheet_title">
				<ul>
					<li class="txt">평가결과피드백</li>
					<li class="btn">
						<a href="javascript:doAction1('Search')" class="button">조회</a>
						<a href="javascript:doAction1('Down2Excel')" class="basic authR">다운로드</a>
					</li>
				</ul>
			</div> -->
		<div class="hr-container">
			<div class="search-group">
				<div class="form-area">
					<div class="form-row">
						<div class="label">조회기간</div>
						<div class="custom-label">
							<input type="radio" id="1year" value="1년" name="year" checked>
							<label for="1year">1년</label>
						</div>
						<div class="custom-label">
							<input type="radio" id="3year" value="3년" name="year">
							<label for="3year">3년</label>
						</div>
						<div class="custom-label">
							<input type="radio" id="5year" value="5년" name="year">
							<label for="5year">5년</label>
						</div>
						<div class="custom-label">
							<input type="radio" id="year" value="직접입력" name="year">
							<label for="year">직접입력</label>
						</div>
						<div class="custom-label">
							<input class="inputbox yearbox" value="2023" type="text" autocomplete="off" placeholder="2023" disabled>
							<p>&#45;</p> <!-- Hyphen -->
							<input class="inputbox yearbox" value="2024" type="text" autocomplete="off" placeholder="2024">
						</div>
					</div>
				</div>
				<div class="btns navy-btns">
					<button class="btn" type="button">조회</button>
				</div>
			</div>
			<div class="no-data">
				<i class="mdo-ico">folder_off</i>
				<p>조회된 결과가 없습니다.</p>
			</div>
		</div>

		<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
	</div>
</body>
</html>