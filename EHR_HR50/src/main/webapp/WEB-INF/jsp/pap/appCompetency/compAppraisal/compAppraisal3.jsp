<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var compAprList = "";
var closeYn = "Y"
var papAdminYn = "${sessionScope.ssnPapAdminYn}";
var grpCd = "${ssnGrpCd}";
//alert(grpCd);
	$(function() {
		
		// 공통코드 조회
		var list = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&sysdateYn=Y","queryId=getCompAppraisalCdList",false).codeList;
		compAprList = list;
		var CompAppraisalCdList = convCode( list, "");
		// 조회조건 값 setting
		$("#searchCompAppraisalCd").html(CompAppraisalCdList[2]);
		// 조회조건 이벤트
		
		if( grpCd == '30'){ // 한국투자증권반영시 4(부실점장 권한)로 변경해야 함
		    var data = ajaxCall("${ctx}/CompAppraisal.do?cmd=getCompAppraisalTeamChk",$("#empForm").serialize(),false);
			if(data != null && data.DATA != null) {
				var chkVal = data.DATA.cnt
				//alert(chkVal)
				if( chkVal > 0 ){
			    	alert("부서원의 평가자들 평가 완료후 조회 할 수 있습니다.");
			    	location.href="/html/contents/base06.html";// 한국투자증권 되는지 확인!!
				}
				
			}
		}
		
	    $(window).smartresize(sheetResize);
		sheetInit();
		
		

		
		

		doAction1("Search");
		
		//차수

		
		$("#searchNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});

		$("#searchCompAppraisalCd").change();
	});

	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction){
		switch(sAction){
			case "Search":
				searchTitleList();
				
				sheet1.DoSearch( "${ctx}/CompAppraisal.do?cmd=getTeamList", $("#empForm").serialize() );
				break;

			case "Down2Excel":	//엑셀내려받기
				sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
				break;


		}
	}
	
	function searchTitleList() {
		var param = "";

		var titleList = ajaxCall("${ctx}/CompAppraisal.do?cmd=getTeamHeaderList", param, false);
		if (titleList != null && titleList.DATA != null) {

			sheet1.Reset();

			var initdata1 = {};
			initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:3, MergeSheet:msHeaderOnly+msPrevColumnMerge};
			initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};

			var colIdx = 0;
			initdata1.Cols = [];
			initdata1.Cols[colIdx++]  = {Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
			initdata1.Cols[colIdx++]  = {Header:"<sht:txt mid='sabunV2' mdef='사번|사번'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			initdata1.Cols[colIdx++]  = {Header:"<sht:txt mid='suname' mdef='성명|성명'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
			initdata1.Cols[colIdx++]  = {Header:"<sht:txt mid='2018050800009' mdef='그룹|그룹'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appGroup",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };

			var i = 0 ; 
			for(; i<titleList.DATA.length; i++) {
				initdata1.Cols[colIdx++] = {Header:titleList.DATA[i].saveNameDisp+"|그룹평균",	Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:titleList.DATA[i].saveName4,		KeyField:0,	Format:"NullFloat",		PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 };
				initdata1.Cols[colIdx++] = {Header:titleList.DATA[i].saveNameDisp+"|직원점수",	Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:titleList.DATA[i].saveName3,		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 };
			}
			initdata1.Cols[colIdx++] = {Header:"<sht:txt mid='avg1' mdef='총점|그룹평균'/>",	Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"avg1",		KeyField:0,	Format:"NullFloat",		PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 };
			initdata1.Cols[colIdx++] = {Header:"<sht:txt mid='avg1' mdef='총점|직원점수'/>",	Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"avg2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 };

			IBS_InitSheet(sheet1, initdata1);
			sheet1.SetCountPosition(0);
		}
	}
	

	//<!-- 조회 후 에러 메시지 -->
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg);
			}
			
			$(window).smartresize(sheetResize);	
			sheetInit();
			
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}
	


</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="empForm" name="empForm" >
		<input type="hidden" id="searchAdminYn" name="searchAdminYn" value="" />

		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select id="searchCompAppraisalCd" name="searchCompAppraisalCd" class="box"></select>
						</td>
						<td>
							<span>대상자(피평가자)</span>
							<input type="text"   id="searchNm"  name="searchNm" class="text w100" style="ime-mode:active"/>
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">다면평가</li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
