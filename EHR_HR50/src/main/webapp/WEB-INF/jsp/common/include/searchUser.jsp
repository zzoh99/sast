<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%> 
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='114312' mdef='임직원 조회'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(document).ready( function() {
		$("#sheet1Form").find("[name=searchKeyword]")
				.keypressEnter(function() {
					doActionSearchUser('Search')
				});
		createIBSheet3($("#divSearchUser").get(0), "sheet1", "100%", "300px","${ssnLocaleCd}");
		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = { SearchMode : smLazyLoad, MergeSheet : 0, Page : 22, FrozenCol : 0, DataRowMerge : 0 , AutoFitColWidth:'init|search|resize|rowtransaction'};
		//HeaderMode
		initdata.HeaderMode = { Sort : 1, ColMove : 1, ColResize : 1, HeaderCheck : 0 };
		//InitColumns + Header Title
		initdata.Cols = [ { Header : "No", Type : "Seq", Hidden : 0, Width : 40, Align : "Center", ColMerge : 0, SaveName : "sNo" }, 
			{ Header : "회사명", Type : "Text", Hidden : 1, Width : 0, Align : "Center", ColMerge : 0, SaveName : "enterNm"}, 
			{ Header : "사번", Type : "Text", Hidden : 0, Width : 70, Align : "Center", ColMerge : 0, SaveName : "empSabun"}, 
			{ Header : "성명", Type : "Text", Hidden : 0, Width : 70, Align : "Center", ColMerge : 0, SaveName : "empName"}, 
			{ Header : "호칭", Type : "Text", Hidden : Number("${aliasHdn}"), Width : 100, Align : "Center", ColMerge : 0, SaveName : "empAlias"}, 
			{ Header : "소속", Type : "Text", Hidden : 0, Width : 130, Align : "Left", ColMerge : 0, SaveName : "orgNm"}, 
			{ Header : "직책", Type : "Text", Hidden : 0, Width : 70, Align : "Center", ColMerge : 0, SaveName : "jikchakNm"}, 
			{ Header : "직급", Type : "Text", Hidden : Number("${jgHdn}"), Width : 70, Align : "Center", ColMerge : 0, SaveName : "jikgubNm"}, 
			{ Header : "직위", Type : "Text", Hidden : Number("${jwHdn}"), Width : 70, Align : "Center", ColMerge : 0, SaveName : "jikweeNm"}, 
			{ Header : "직무", Type : "Text", Hidden : 0, Width : 200, Align : "Left", ColMerge : 0, SaveName : "jobNm", Wrap : 1, MultiLineText : 1}, 
			{ Header : "공통사무", Type : "Text", Hidden : 0, Width : 100, Align : "Left", ColMerge : 0, SaveName : "taskNm", Wrap : 1, MultiLineText : 1}, 
			{ Header : "직위", Type : "Text", Hidden : 1, Width : 100, Align : "Center", ColMerge : 0, SaveName : "jikweeNm"}, 
			{ Header : "직급", Type : "Text", Hidden : 1, Width : 100, Align : "Center", ColMerge : 0, SaveName : "jikgubNm"}, 
			{ Header : "재직\n상태", Type : "Text", Hidden : 0, Width : 50, Align : "Center", ColMerge : 0, SaveName : "statusNm"} 
		];
		IBS_InitSheet(sheet1, initdata);
		sheet1.SetCountPosition(4);
		sheet1.SetEditableColorDiff(0);
		sheet1.SetEditable(0);
		sheetInit();
		$("#sheet1Form #searchKeyword").focus();
	});
	//임직원검색 조회
	function doActionSearchUser(sAction) {
		switch (sAction) {
		case "Search": //조회
			if (($.trim($("#sheet1Form #searchKeyword").val())) == "" && ($.trim($("#sheet1Form #searchKeyword2").val())) == "" ) {
				alert("성명/사번 또는 직무를 입력하세요.");
				$("#sheet1Form #searchKeyword").focus();
			} else {
				sheet1.DoSearch("${ctx}/Employee.do?cmd=employeeList",$("#sheet1Form").serialize(), 1);
			}
			break;
		}
	}
	// 임직원검색 조회
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try {
			if (sheet1.RowCount() == 0) {
				alert("<msg:txt mid='alertAuthEmp1' mdef='대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.'/>");
			} else {
				showDivSearchUser();
			}

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	// 임직원검색 클릭
	function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW,
			CellH) {
		if (Row > 0) {
			var empSabun = sheet1.GetCellValue(Row, "empSabun");
			var json = ajaxCall("${ctx}/Employee.do?cmd=getBaseEmployeeDetail", {
				selectedUserId : empSabun,
				searchStatusCd : $("input[name=searchStatusRadio]:checked")
						.val()
			}, false);
			var user = json.map;
			var tempOb = $("#divSerchUserResultTable");

			tempOb.find("img#photo").attr("src",
					"/EmpPhotoOut.do?searchKeyword=" + user.sabun);
			for (key in user) {
				if (tempOb.find("span[name=" + key + "]").size() > 0) {
					tempOb.find("span[name=" + key + "]").html(replaceAll(user[key],"\n","<br>") || "");
				}
			}
			showDivSearchUser("result");
		}
	}
	//임직원검색 결과창 뷰전환
	function showDivSearchUser(p) {
		if (p == "result") {
			$("#divSearchUser").hide();
			$("#divSearchUserResult").show("slide", {
				direction : "right"
			}, 500);
		} else {
			$("#divSearchUserResult").hide();
			$("#divSearchUser").show("slide", {
				direction : "left"
			}, 500);
		}
	}
</script>
</head>
<body class="bodywrap" style="margin:20px 20px 0px 20px">
	<div class="wrapper">
		<div>
			<form id="sheet1Form" name="sheet1Form">
				<input type="hidden" id="searchEmpType" name="searchEmpType" value="T" />
				<div class="sheet_search outer">
					<div>
						<table>
							<tr>
								<th><tit:txt mid='112947' mdef='성명/사번'/></th>
								<td><input id="searchKeyword" name="searchKeyword" type="text" class="text" style="ime-mode: active;" /></td>
								<th><tit:txt mid='103973' mdef='직무'/></th> 
								<td><input id="searchKeyword2" name="searchKeyword2" type="text" class="text" style="ime-mode: active;" /></td>
								<td>
									<input name="searchStatusRadio" checked="checked" type="radio" class="radio" value="RA" /> <tit:txt mid='113521' mdef='퇴직자 제외'/>
									<input name="searchStatusRadio" type="radio" class="radio" value="A" /> <tit:txt mid='114221' mdef='퇴직자 포함'/>
								</td>
								<td><a href="javascript:doActionSearchUser('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a></td>
							</tr>
						</table>
					</div>
				</div>
			</form>
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='schEmployee' mdef='사원조회'/></li>
					</ul>
				</div>
			</div>
			<div id="divSearchUser" style="height: 300px"></div>
			<div id="divSearchUserResult" style="display: none; height: 300px;">
				<div id="divSerchUserResultTable">
					<table>
						<colgroup>
							<col width="200px">
							<col width="10px">
							<col width="700px">
						</colgroup>
						<tbody>
							<tr>
								<td class="center"><img src="#" id="photo" width="100" height="121" onerror="javascript:this.src='/common/images/common/img_photo.gif'"></td>
								<td></td>
								<td>
									<table class="table">
										<colgroup>
											<col width="20%">
											<col width="30%">
											<col width="20%">
											<col width="50%">
										</colgroup>
										<tbody>
											<tr>
												<th><tit:txt mid='103880' mdef='성명'/></th>
												<td><span name="empName" /></td>
												<th><tit:txt mid='103975' mdef='사번'/></th>
												<td><span name="sabun" /></td>
											</tr>
											<tr>
												<th>호칭</th>
												<td><span name="empAlias" /></td>
												<th><tit:txt mid='103785' mdef='직책'/></th>
												<td><span name="jikchakNm" /></td>
											</tr>
											<c:choose>
											<c:when test="${ssnJikgubUseYn == 'Y' && ssnJikweeUseYn == 'Y'}">
												<tr>
													<th><tit:txt mid='104471' mdef='직급'/></th>
													<td><span name="jikgubNm" /></td>
													<th><tit:txt mid='104104' mdef='직위'/></th>
													<td><span name="jikweeNm" /></td>
												</tr>
											</c:when>
											<c:when test="${ssnJikgubUseYn == 'Y'}">
												<tr>
													<th><tit:txt mid='104471' mdef='직급'/></th>
													<td><span name="jikgubNm" /></td>
													<th></th>
													<td></td>
												</tr>
											</c:when>
											<c:when test="${ssnJikweeUseYn == 'Y'}">
												<tr>
													<th><tit:txt mid='104104' mdef='직위'/></th>
													<td><span name="jikweeNm" /></td>
													<th></th>
													<td></td>
												</tr>
											</c:when>
											</c:choose>
											<tr>
												<th><tit:txt mid='104279' mdef='소속'/></th>
												<td colspan="3"><span name="orgNm" /></td>
											</tr>
											<tr>
												<th><tit:txt mid='103973' mdef='직무'/></th>
												<td><span name="jobNm" /></td>
												<th>공통사무</th>
												<td><span name="taskNm" /></td>
											</tr>
											<tr>
												<th><tit:txt mid='114132' mdef='사내전화'/></th>
												<td><span name="inNum" /></td>
												<th><tit:txt mid='103945' mdef='휴대폰'/></th>
												<td><span name="phone" /></td>
											</tr>
											<tr>
												<th>E-Mail</th>
												<td colspan="3"><span name="email" /></td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<p style="text-align: center; font-size: 18px;">
					<a href="javascript:showDivSearchUser();"><img src="${ctx}/common/images/common/btn_left_close.gif" style="vertical-align: middle;" />검색결과로</a>
				</p>
			</div>
		</div>
	</div>	
</body>
</html>
