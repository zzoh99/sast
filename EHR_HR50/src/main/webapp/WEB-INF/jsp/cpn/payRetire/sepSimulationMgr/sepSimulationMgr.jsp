<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!-- 날짜 콤보 박스 생성을 위함 -->
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!-- 날짜 콤보 박스 생성을 위함 -->

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {
		$(window).smartresize(sheetResize);
		sheetInit();


		//사번셋팅
		setEmpPage();
		
		doAction1("Search");
	});

	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				doAction1("Clear");

				$("#sabun"		).val(parent.$("#sabun").val());
				$("#payActionCd").val(parent.$("#payActionCd").val());

				// 지급항목/공제내역/급여기초/과표내역/비과세내역 조회
				var sepSimulationInfo = ajaxCall("${ctx}/SepSimulationMgr.do?cmd=getSepSimulationMgr", $("#sheet1Form").serialize(), false);
				if (sepSimulationInfo.DATA != null && typeof sepSimulationInfo.DATA != "undefined") {
					$("#empYmd").val(formatDate(sepSimulationInfo.DATA.empYmd,'-'));
					$("#rmidYmd").val(formatDate(sepSimulationInfo.DATA.rmidYmd,'-'));
					$("#sepSymd").val(formatDate(sepSimulationInfo.DATA.sepSymd,'-'));
					$("#sepEymd").val(formatDate(sepSimulationInfo.DATA.sepEymd,'-'));
					$("#wkpDCnt").val(sepSimulationInfo.DATA.wkpDCnt);
					$("#wkpAllDCnt").val(sepSimulationInfo.DATA.wkpAllDCnt + "일");
					$("#avgMonTit").html(sepSimulationInfo.DATA.avgMonTitle);
					$("#avgMon").val(sepSimulationInfo.DATA.avgMon.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
					$("#sepRule").val(sepSimulationInfo.DATA.sepRule);
					$("#earningMon").val(sepSimulationInfo.DATA.earningMon.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
					$("#eSepRule").val(sepSimulationInfo.DATA.eSepRule);
				}
				break;

			case "Proc":
				if (!confirm("예상퇴직금을 계산하시겠습니까?")) return;
				progressBar(true) ;
				
				setTimeout(
					function(){
				    	
						var data = ajaxCall("${ctx}/SepSimulationMgr.do?cmd=prcPCpnSepSimulation", $("#sheet1Form").serialize(),false);
				    	if(data.Result.Code == null) {
				    		doAction1("Search");
				    		alert("<msg:txt mid='alertPrcJobOk' mdef='작업 완료되었습니다.'/>");
					    	progressBar(false) ;
					    	modApplyCd();
							doAction1("Search");
				    	} else {
					    	alert("<msg:txt mid='2021081100939' mdef='처리중 오류가 발생했습니다.'/>\n"+data.Result.Message);
					    	progressBar(false) ;
				    	}
					}
				, 100);
				break;
			case "Clear":
				$("#empYmd").val("");
				$("#rmidYmd").val("");
				$("#sepSymd").val("");
				$("#sepEymd").val("");
				$("#wkpDCnt").val("");
				$("#avgMon").val("");
				$("#sepRule").val("");
				$("#earningMon").val("");
				$("#eSepRule").val("");
		}
	}


	//인사헤더에서 이름 변경 시 호출 됨 
    function setEmpPage() {
    	$("#searchSabun").val($("#searchUserId").val());
    	doAction1("Search");
    }
</script>
<style>
.thColorSet {background-color:#70c8d321  !important;}
</style>
</head>
<body class="hidden">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="searchSabun" name="searchSabun" class="text" value="" />
		<input type="hidden" id="searchYmd" name="searchYmd" value="" />
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div id="outer1" class="sheet_title outer">
				<ul>
					<li class="txt"><tit:txt mid='2021110202466' mdef='예상퇴직금'/><span style="vertical-align:unset;padding-left:20px;color:red;">※ 문의사항은 인사팀에 연락 바랍니다.</span></li>
					<li class="btn">
						<a href="javascript:doAction1('Proc');" class="button authA"><tit:txt  mid='112097'   mdef='계산'/></a>
						<a href="javascript:doAction1('Search');" class="button authR"><tit:txt  mid='104081' mdef='조회'/></a>
					</li>
				</ul>
				</div>
			</td>
		</tr>
		<tr>
			<td class="sheet_left">
				<div id="payTableDiv" style="overflow:auto;border:1px solid #dae1e6;">
				<table border="1px solid" cellpadding="0" cellspacing="0" class="default outer" style="margin-bottom:0px">
					<colgroup>
						<col width="10%" />
						<col width="30%" />
						<col width="10%" />
						<col width="50%" />
					</colgroup>
					<tr>
						<th class="center" colspan="4" style="text-align: left !important; background-color:#70c8d378"><tit:txt  mid='2021110202471'   mdef='[근속정보]'/></th>
					</tr>
					<tr>
						<th class="center thColorSet"><tit:txt  mid='103881'   mdef='입사일'/></th>
						<td><input type="text" id="empYmd" name="empYmd" class="text transparent" readonly style="width:100%; text-align:center;"/></td>
						<th class="center thColorSet"><tit:txt  mid='104188'   mdef='최종중간정산일'/></th>
						<td><input type="text" id="rmidYmd" name="rmidYmd" class="text transparent" readonly style="width:100%; text-align:center;"/></td>
					</tr>
					<tr>
						<th class="center thColorSet"><tit:txt  mid='2021110202472'   mdef='기산시작일'/></th>
						<td><input type="text" id="sepSymd" name="sepSymd" class="text transparent" readonly style="width:100%; text-align:center;"/></td>
						<th class="center thColorSet"><tit:txt  mid='2021110202473'   mdef='기산종료일'/></th>
						<td><input type="text" id="sepEymd" name="sepEymd" class="text transparent" readonly style="width:100%; text-align:center;"/></td>
					</tr>
					<tr>
						<th class="center thColorSet"><tit:txt  mid='113531'   mdef='근속기간'/></th>
						<td><input type="text" id="wkpDCnt" name="wkpDCnt" class="text transparent" readonly style="width:100%;"/></td>
						<th class="center thColorSet"><tit:txt  mid='114580'   mdef='근속일수'/></th>
						<td><input type="text" id="wkpAllDCnt" name="wkpAllDCnt" class="text transparent" readonly style="width:100%;"/></td>
					</tr>
					<tr>
						<th class="center" colspan="4" style="text-align: left !important; background-color:#70c8d378">[퇴직소득]</th>
					</tr>
					<tr>
						<th class="center thColorSet" id="avgMonTit" name ="avgMonTit"></th>
						<td><input type="text" id="avgMon" name="avgMon" class="text transparent" readonly style="width:100%; text-align:center;"/></td>
						<td colspan="2" class="thColorSet"><input type="text" id="sepRule" name="sepRule" class="text transparent" readonly style="width:100%;"/></td>
					</tr>
					<tr>
						<th class="center" style="background-color:#008fd5;color:#fff"><tit:txt  mid='2021110202476'   mdef='퇴직소득'/></th>
						<td style="background-color:#ffc300"><input type="text" id="earningMon" name="earningMon" class="text transparent" readonly style="width:100%; text-align:center;"/></td>
						<td colspan="2" class="thColorSet"><input type="text" id="eSepRule" name="eSepRule" class="text transparent" readonly style="width:100%;"/></td>
					</tr>
				</table>
				</div>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
