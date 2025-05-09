<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>기타공제</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ include file="yeaDataCommon.jsp"%>

<%String orgAuthPg = request.getParameter("orgAuthPg");%>

<script type="text/javascript">
	var orgAuthPg = "<%=removeXSS(orgAuthPg, '1')%>";
	//도움말
	var helpText;
	//기준년도
	var systemYY;
	
	//총급여
    var paytotMonStr;
	//총급여 확인 버튼 보여주기 유무 정보에 따라 컨트롤
    var yeaMonShowYn;

	$(function() {
		/*필수 기본 세팅*/
		$("#searchWorkYy").val( 	$("#searchWorkYy", parent.document).val() 		) ;
		$("#searchAdjustType").val( $("#searchAdjustType", parent.document).val() 	) ;
		$("#searchSabun").val( 		$("#searchSabun", parent.document).val() 		) ;
		systemYY = $("#searchWorkYy", parent.document).val();

		$("#A100_30").mask('000,000,000,000,000', {reverse: true});
		$("#A100_11").mask('000,000,000,000,000', {reverse: true});
		//$("#A100_08").mask('000,000,000,000,000', {reverse: true});
		//$("#A100_10").mask('000,000,000,000,000', {reverse: true});
		//$("#A100_09").mask('000,000,000,000,000', {reverse: true});
		//$("#A100_12").mask('000,000,000,000,000', {reverse: true});
		$("#A100_21").mask('000,000,000,000,000', {reverse: true});
		$("#A100_37").mask('000,000,000,000,000', {reverse: true});
		$("#A100_38").mask('000,000,000,000,000', {reverse: true});
		$("#A100_55").mask('000,000,000,000,000', {reverse: true});
		$("#A100_56").mask('000,000,000,000,000', {reverse: true});
		
		<%//2015년 추가 start %>
		$("#A100_57").mask('000,000,000,000,000', {reverse: true});
		$("#A100_58").mask('000,000,000,000,000', {reverse: true});
        <%//2015년 추가 end %>
        
        <%//2016년 추가 start %>
		$("#A100_59").mask('000,000,000,000,000', {reverse: true});
		$("#A100_60").mask('000,000,000,000,000', {reverse: true});
        <%//2016년 추가 end %>

		//기본정보 조회(도움말 등등).
		initDefaultData() ;

		//기본자료 조회
		parent.doSearchCommonSheet();
		
		
		if( yeaMonShowYn == "Y"){
            $("#paytotMonViewYn1").show() ;
            $("#paytotMonViewYn2").show() ;
        }else if(yeaMonShowYn == "A"){
            if(orgAuthPg == "A") {
                $("#paytotMonViewYn1").show() ;
                $("#paytotMonViewYn2").show() ;
            }else{
                $("#paytotMonViewYn1").hide() ;
                $("#paytotMonViewYn2").hide() ;
            } 
        }else{
            $("#paytotMonViewYn1").hide() ;
            $("#paytotMonViewYn2").hide() ;
        }
	});

	//기본데이터 조회
	function initDefaultData() {
		//도움말 조회
		var param1 = "searchWorkYy="+$("#searchWorkYy").val();
		param1 += "&queryId=getYeaDataHelpText";

		var result1 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param1+"&adjProcessCd=A100",false);
		helpText = nvl(result1.Data.help_text1,"") + nvl(result1.Data.help_text2,"") + nvl(result1.Data.help_text3,"");
		
		//개인별 총급여
        var param2 = "searchWorkYy="+$("#searchWorkYy").val();
        param2 += "&searchAdjustType="+$("#searchAdjustType").val();
        param2 += "&searchSabun="+$("#searchSabun").val();
        param2 += "&queryId=getYeaDataPayTotMon";

        var result2 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param2+"&searchNumber=1",false);
        paytotMonStr = nvl(result2.Data.paytot_mon,"");

        
		//총급여 확인 버튼 유무
        var result4 = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_MON_SHOW_YN", "queryId=getSystemStdData",false).codeList;
        yeaMonShowYn = nvl(result4[0].code_nm,"");
	}

	//기본자료 설정.
	function sheetSet(){
		var comSheet = parent.commonSheet;

		if(comSheet.RowCount() > 0){
			$("#A100_30").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_30"),"input_mon"));
			$("#A100_11").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_11"),"input_mon"));
			//$("#A100_08").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_08"),"input_mon"));
			//$("#A100_10").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_10"),"input_mon"));
			//$("#A100_09").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_09"),"input_mon"));
			//$("#A100_12").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_12"),"input_mon"));
			$("#A100_21").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_21"),"input_mon"));
			$("#A100_37").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_37"),"input_mon"));
			$("#A100_38").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_38"),"input_mon"));
			$("#A100_55").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_55"),"input_mon"));
			$("#A100_56").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_56"),"input_mon"));
			
			<%//2015년 추가 start %>
			$("#A100_57").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_57"),"input_mon"));
			$("#A100_58").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_58"),"input_mon"));
            <%//2015년 추가 end %>
			
            <%//2016년 추가 start %>
			$("#A100_59").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_59"),"input_mon"));
			$("#A100_60").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_60"),"input_mon"));
            <%//2016년 추가 end %>
            
		} else {
			$("#A100_30").val("");
			$("#A100_11").val("");
			//$("#A100_08").val("");
			//$("#A100_10").val("");
			//$("#A100_09").val("");
			//$("#A100_12").val("");
			$("#A100_21").val("");
			$("#A100_37").val("");
			$("#A100_38").val("");
			$("#A100_55").val("");
			$("#A100_56").val("");
			
			<%//2015년 추가 start %>
			$("#A100_57").val("");
			$("#A100_58").val("");
            <%//2015년 추가 end %>
            
            <%//2016년 추가 start %>
			$("#A100_59").val("");
			$("#A100_60").val("");
            <%//2016년 추가 end %>
		}
	}

	//연말정산 안내
	function yeaDataExpPopup(title, helpText, height, width){
		var url 	= "<%=jspPath%>/common/yeaDataExpPopup.jsp";
		openYeaDataExpPopup(url, width, height, title, helpText);
	}

	//데이터 저장.
	function saveCommonData(){
		var comSheet = parent.commonSheet;

		if(comSheet.RowCount() == 0) {
			return;
		} else {
			parent.doInsertCommonSheet("A100_11",$("#A100_11").val());
			//parent.doInsertCommonSheet("A100_08",$("#A100_08").val());
			//parent.doInsertCommonSheet("A100_10",$("#A100_10").val());
			//parent.doInsertCommonSheet("A100_09",$("#A100_09").val());
			//parent.doInsertCommonSheet("A100_12",$("#A100_12").val());
			parent.doInsertCommonSheet("A100_21",$("#A100_21").val());
			parent.doInsertCommonSheet("A100_30",$("#A100_30").val());
			parent.doInsertCommonSheet("A100_37",$("#A100_37").val());
			parent.doInsertCommonSheet("A100_38",$("#A100_38").val());
			parent.doInsertCommonSheet("A100_55",$("#A100_55").val());
			parent.doInsertCommonSheet("A100_56",$("#A100_56").val());
			<%//2015년 추가 start %>
			parent.doInsertCommonSheet("A100_57",$("#A100_57").val());
			parent.doInsertCommonSheet("A100_58",$("#A100_58").val());
			<%//2015년 추가 end %>
			<%//2016년 추가 start %>
			parent.doInsertCommonSheet("A100_59",$("#A100_59").val());
			parent.doInsertCommonSheet("A100_60",$("#A100_60").val());
			<%//2016년 추가 end %>
			parent.doSaveCommonSheet();
		}
		//parent.getYearDefaultInfoObj();
	}

	function sheetChangeCheck() {
		return false;
	}
	
	//[총급여] 보이기
    function paytotMonView(){
        if(paytotMonStr != ""){
            
            if( ( paytotMonStr.replace(/,/gi, "") *1 ) > 70000000 ) {
                $("#span_paytotMonView2").html("<B>YES</B>&nbsp;<a href='javascript:paytotMonViewClose()' ><font color='red'>[닫기]</font></a>") ;
            }else{  
                $("#span_paytotMonView2").html("<B>NO</B>&nbsp;<a href='javascript:paytotMonViewClose()' ><font color='red'>[닫기]</font></a>") ;
            }
        } else {
            alert("총급여 내역이 없습니다. 관리자에게 문의해 주십시요.");
        }
    }
    
    //[총급여] 닫기
    function paytotMonViewClose(){
       $("#span_paytotMonView2").html("");
    }
    
</script>
</head>
<body  style="overflow-x:hidden;overflow-y:auto;">
<div class="wrapper">

	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
	<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />
	</form>

	<div class="outer">
    <div class="sheet_title">
        <ul>
            <li class="txt"> 소기업·소상공인 공제부금
            	<span id="paytotMonViewYn2">
                    <a href="javascript:paytotMonView();" class="basic authA"><b><font color="red">[총급여 7천만원 초과여부]</font></b></a>
                </span>
                <span id="span_paytotMonView2" ></span>
            	<a href="javascript:yeaDataExpPopup('소기업·소상공인 공제부금', helpText, 520);" class="cute_gray authR">소기업·소상공인 공제부금</a>
            </li>
            <li class="btn">
		        <a href="javascript:saveCommonData();"	class="basic authA">저장</a>
    		</li>
        </ul>
    </div>
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="default outer yeaData1">
	<colgroup>
		<col width="20%" />
		<col width="20%" />
		<col width="" />
	</colgroup>
	<tr>
		<th class="left">납입금액</th>
		<td class="right">
			<input id="A100_30" name="A100_30" type="text" class="text w90 right" /> 원
		</td>
		<td class="left">
			&nbsp;거주자가 중소기업협동조합법 제115조에 따른 소기업ㆍ소상공인 공제에 가입하여 해당 과세기간에 납부하는 공제부금 <br>
			&nbsp;2016년 이후 가입한 경우에는 법인대표자로서 총급여 7천만원 이하인 경우에만 공제 가능
		</td>
	</tr>
	</table>
	<div class="outer">
    <div class="sheet_title">
        <ul>
            <li class="txt">창업투자조합 출자 등 소득공제
            	<a href="javascript:yeaDataExpPopup('창업투자조합 출자 등 소득공제', helpText, 520);" class="cute_gray authR">창업투자조합 출자 등 소득공제 안내</a>
            </li>
            <li class="btn">
    		</li>
        </ul>
    </div>
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="default outer yeaData1">
	<colgroup>
		<col width="10%" />
		<col width="10%" />
		<col width="20%" />
		<col width="" />
	</colgroup>
	<!-- tr>
		<th class="center" rowspan=2>2012.1.1 ~ 2012.12.31</th>
		<th class="left">간접출자</th>
		<td class="right">
			<input id="A100_08" name="A100_08" type="text" class="text w90 right" /> 원
		</td>
		<td class="left" rowspan="8">
			&nbsp;거주자가 중소기업창업투자조합 등에 2015년 12월 31일까지 출자 또는 투자한 금액<br>
			&nbsp;그 출자일 또는 투자일이 속하는 과세연도부터 2년이 되는 날이 속하는<br>
            &nbsp;과세연도까지 거주자가 선택하는 1과세연도의 종합소득금액에서 공제<br>
			&nbsp;<b>공제한도 : Min(ㄱ,ㄴ)</b><br>
			&nbsp;ㄱ.출자 또는 투자한 금액 10% <br>
			&nbsp;&nbsp;2013년도 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 30%<br>
			&nbsp;&nbsp;2014년도 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br>
			&nbsp;&nbsp;&nbsp;&nbsp;5천만원 이하분은 50%, 5천만원 초과분은 30% <br>
			&nbsp;&nbsp;2015년도 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br>
			&nbsp;&nbsp;&nbsp;&nbsp;1천5백만원 이하분은 100%, 5천만원 이하분은 50%, 5천만원 초과분은 30% <br>
			&nbsp;ㄴ.해당년도 종합소득금액 50% <br>
			&nbsp;&nbsp;(단, 2013년도 이전은 40%) <br>
		</td>
	</tr>
	<tr>
		<th class="left">직접출자</th>
		<td class="right">
			<input id="A100_10" name="A100_10" type="text" class="text w90 right" /> 원
		</td>
	</tr -->
	<tr>
		<th class="center" rowspan=2>2014.1.1 ~ 2014.12.31</th>
		<th class="left">간접출자</th>
		<td class="right">
			<input id="A100_55" name="A100_55" type="text" class="text w90 right" /> 원
		</td>
		<td class="left" rowspan="6">
			&nbsp;거주자가 중소기업창업투자조합 등에 2017년 12월 31일까지 출자 또는 투자한 금액<br>
			&nbsp;그 출자일 또는 투자일이 속하는 과세연도부터 2년이 되는 날이 속하는<br>
            &nbsp;과세연도까지 거주자가 선택하는 1과세연도의 종합소득금액에서 공제<br>
			&nbsp;공제한도 : Min(ㄱ,ㄴ)<br>
			&nbsp;ㄱ.출자 또는 투자한 금액 10% <br>
			<!-- &nbsp;&nbsp;&nbsp;&nbsp;2013년도 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 30%<br> -->
			&nbsp;&nbsp;&nbsp;&nbsp;2014년 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5천만원 이하분은 50%, 5천만원 초과분은 30% <br>
			&nbsp;&nbsp;&nbsp;&nbsp;2015년 이후분 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1천5백만원 이하분은 100%, 5천만원 이하분은 50%, 5천만원 초과분은 30% <br>
			&nbsp;ㄴ.해당년도 종합소득금액 50% <br>
			<!-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(단, 2013년도 이전은 40%) <br>-->
		</td>
	</tr>
	<tr>
		<th class="left">직접출자</th>
		<td class="right">
			<input id="A100_56" name="A100_56" type="text" class="text w90 right" /> 원
		</td>
	</tr>
	<tr>
		<th class="center" rowspan=2>2015.1.1 ~ 2015.12.31</th>
		<th class="left">간접출자</th>
		<td class="right">
			<input id="A100_57" name="A100_57" type="text" class="text w90 right" /> 원
		</td>
	</tr>
	<tr>
		<th class="left">직접출자</th>
		<td class="right">
			<input id="A100_58" name="A100_58" type="text" class="text w90 right" /> 원
		</td>
	</tr>
	<%// 2015년 추가 Start %>
	<tr>
        <th class="center" rowspan=2>2016.1.1 ~ 2016.12.31</th>
        <th class="left">간접출자</th>
        <td class="right">
            <input id="A100_59" name="A100_59" type="text" class="text w90 right" /> 원
        </td>
    </tr>
    <tr>
        <th class="left">직접출자</th>
        <td class="right">
            <input id="A100_60" name="A100_60" type="text" class="text w90 right" /> 원
        </td>
    </tr>
    <%// 2015년 추가 End %>
	</table>
	<div class="outer">
    <div class="sheet_title">
        <ul>
            <li class="txt">우리사주조합출연금
            	<a href="javascript:yeaDataExpPopup('우리사주조합출연금', helpText, 520);" class="cute_gray authR">우리사주조합출연금 안내</a>
            </li>
            <li class="btn">
    		</li>
        </ul>
    </div>
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="default outer yeaData1">
	<colgroup>
		<col width="20%" />
		<col width="20%" />
		<col width="" />
	</colgroup>
	<tr>
		<th class="left">우리사주 출연금</th>
		<td class="right">
			<input id="A100_21" name="A100_21" type="text" class="text w90 right" /> 원
		</td>
		<td class="left" rowspan="3">
			&nbsp;우리사주조합원이 자사주를 취득하기 위하여 우리사주조합에 출자하는 경우 해당 연도의 출자금액과 <br>
			&nbsp;400만원 중 적은 금액을 공제
		</td>
	</tr>
	</table>
	<div class="outer">
    <div class="sheet_title">
        <ul>
            <li class="txt">고용유지중소기업근로자
            	<a href="javascript:yeaDataExpPopup('고용유지중소기업근로자', helpText, 520);" class="cute_gray authR">고용유지중소기업근로자 안내</a>
            </li>
            <li class="btn">
    		</li>
        </ul>
    </div>
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="default outer yeaData1">
	<colgroup>
		<col width="20%" />
		<col width="20%" />
		<col width="" />
	</colgroup>
	<tr>
		<th class="left">임금감소액</th>
		<td class="right">
			<input id="A100_37" name="A100_37" type="text" class="text w90 right" /> 원
		</td>
		<td class="left" rowspan="3">
			&nbsp;임금감소액 : 직전 과세연도의 해당 근로자 연간 임금총액 - 해당 과세연도의 해당 근로자<br>
			&nbsp;연간 임금총액 고용유지중소기업에 근로를 제공하는 상시근로자에 대하여 2018년 12월 31일이<br>
			&nbsp;속하는 과세연도까지 다음 산식에 따라 계산한 금액을 해당 과세연도의 근로소득금액에서 공제
		</td>
	</tr>
	</table>
	<div class="outer hide">
		<div class="sheet_title">
			<ul>
				<li class="txt">목돈안드는전세이자상환액
					<a href="javascript:yeaDataExpPopup('목돈안드는전세이자상환액', helpText, 520);" class="cute_gray authR">목돈안드는전세이자상환액 안내</a>
				</li>
				<li class="btn">
				</li>
			</ul>
		</div>
	</div>
	<table border="0" cellpadding="0" cellspacing="0" class="default outer hide yeaData1">
	<colgroup>
		<col width="20%" />
		<col width="20%" />
		<col width="" />
	</colgroup>
	<tr>
		<th class="left">이자상환액</th>
		<td class="right">
			<input id="A100_38" name="A100_38" type="text" class="text w90 right" /> 원
		</td>
		<td class="left" rowspan="3">
			임차인이 불입한 당해년도 이자상환액 전액을 입력하여 주십시오.(요건은 다음과 같습니다.)<br>
			 - (임대인) 보유주택을 담보로 금융기관으로부터 전세보증금을 차입<br>
			 - (임차인) 부부합산 연소득 6천만원 이하인 무주택자<br>
			 - (대출한도) 3천만원 (수도권 5천만원)<br>
			 - (대출이자) 주택 임차인이 상환<br>
			 - 공제금액 : 임대인이 이자상환액의 40% 공제(연 300만원 한도)<br>
		</td>
	</tr>
	</table>
	
</div>
</body>
</html>