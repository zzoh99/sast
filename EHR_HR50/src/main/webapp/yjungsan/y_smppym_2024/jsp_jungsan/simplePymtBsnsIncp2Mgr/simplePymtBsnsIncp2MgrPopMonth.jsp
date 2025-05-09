<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말_사업소득 생성</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");
    var arg    = p.window.dialogArguments;
    var authPg = "";
 
    $(function(){
        $(".close").click(function()  { p.self.close(); });

        if(typeof arg == "undefined" ) {

            var workYy 	  = "";
            var searchGb  = "";
			
            workYy 	  	= p.popDialogArgument("workYy");
            workMm 	  	= p.popDialogArgument("workMm");
            searchGb	= p.popDialogArgument("searchGb");
            halfType 	  	= p.popDialogArgument("halfType");
			
			//근로/사업/비거주자 구분
        	$("#searchGb").val(searchGb);
        	//title명
        	$("#titleNm").text(searchGb+" 소득 생성");
        	//지급년도
        	$("#workYy").val(workYy);
        	//월
        	$("#workMm").val(workMm);
        	//상/하반기
        	$("#halfType").val(halfType);

            
        }

        if( arg != "undefined" ) {

        	//근로/사업/비거주자 구분
        	$("#searchGb").val(arg["searchGb"]);
        	//title명
        	$("#titleNm").text(arg["searchGb"]+" 소득 생성");
        	//지급년도
        	$("#workYy").val(arg["workYy"]);
        	//월
        	$("#workMm").val(arg["workMm"]);
        	//상/하반기
        	$("#halfType").val(arg["halfType"]);
        }
       

    });
    
    
	// 생성 프로시저 팝업호출
	function callProc() {
		
		var delYn = "";
		
		// 삭제여부
		if($("input:radio[name='rdBtn']").filter("input[value='01']").attr("checked") == "checked"){
			delYn = "Y";
		}else{
			delYn = "N";
		}
		
		//정산구분
		var calcType = $("input:radio[name='rdBtnCalcType']:checked").val();
		
		var today = new Date();
		var yyyy = today.getFullYear();

		// 소득구분코드 (근로 : 77 / 사업 : 50 / 비거주자 : 49 / 연말_사업 : 61)
		var incomeType = "61";
		// 정산년도
		var workYy = $("#workYy").val();
		// 월
		var workMm = $("#workMm").val();
		// 상/하반기
		var halfType = $("#halfType").val();
		// 지급년도
		var creWorkYy = yyyy;
		
		$("#halfType").val(halfType);
		$("#incomeType").val(incomeType);
		$("#creWorkYy").val(creWorkYy);
		$("#workYy").val(workYy);
		$("#workMm").val(workMm);
		$("#delYn").val(delYn);
		$("#calcType").val(calcType);

		 // 자료생성
		var data = ajaxCall("<%=jspPath%>/simplePymtBsnsIncp2Mgr/simplePymtBsnsIncp2MgrMonthRst.jsp?cmd=P_CPN_SMPPYM_EMP",$("#sheet1Form").serialize(),false);
		 
		if(data.Result.Code == 1) {
			p.self.close();
			var returnValue = new Array()
			returnValue["result"]		= "Y";
			
			if(p.popReturnValue) p.popReturnValue(returnValue);
		}
		
		else {
			msg = "처리도중 문제발생 : "+data.Result.Message;
		}
		

	}

</script>
</head>
<body class="bodywrap">
    <div class="wrapper popup_scroll">

        <div class="popup_main">
        <form id="sheet1Form" name="sheet1Form">
            <input id="searchGb" name="searchGb" type="hidden" value="" />
            <input id="workYy" name="workYy" type="hidden" value="" />
            <input id="workMm" name="workMm" type="hidden" value="" />
            <input id="halfType" name="halfType" type="hidden" value="" />
            <input id="incomeType" name="incomeType" type="hidden" value="" />
            <input id="creWorkYy" name="creWorkYy" type="hidden" value="" />
            <input id="delYn" name="delYn" type="hidden" value="" />
            <input id="calcType" name="calcType" type="hidden" value="" />
        </form>
        
    <table border="0" cellspacing="0" cellpadding="0" class="sheet_main" style="margin-top: 40px;">

	<tr>
		<td class="">
			<div class="inner">
				<table class="table w100p" id="htmlTable">
					<colgroup>
						<col width="%" />
					</colgroup>
					<tr>
						<th style="text-align: center; font-size: 20px; font-weight: bold" id="titleNm">
						</th>
					</tr>
				</table>
			</div>

		</td>
	</tr>
	<tr>
		<td class="">
			<div class="inner">
				<table class="table w100p">
					<colgroup>
						<col width="80%" />
						<col width="20%" />
					</colgroup>
					<tr>
						<th style="font-size: 15px;">지급년월</th>
						<td><input style="margin-left: 35px;" type="radio" name="rdBtnCalcType" value="1" checked /></td>
						
					</tr>
					<tr>
						<th style="font-size: 15px;">귀속년월</th>
						<td><input style="margin-left: 35px;" type="radio" name="rdBtnCalcType" value="2"/></td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
	<tr>
		<td class="">
			<div class="inner">
				<table class="table w100p" id="htmlTable">
					<colgroup>
						<col width="80%" />
						<col width="20%" />
					</colgroup>
					<tr>
						<th style="font-size: 15px;">기존 데이터 삭제 후 재생성</th>
						<td><input style="margin-left: 35px;" type="radio" id="rdBtn" name="rdBtn" value="01" checked /></td>
						
					</tr>
					<tr>
						<th style="font-size: 15px;">기존 데이터 외 변화 없이 생성</th>
						<td><input style="margin-left: 35px;" type="radio" id="rdBtn" name="rdBtn" value="02"/></td>
					</tr>
				</table>
			</div>

		</td>
	</tr>
	</table>

    <div class="popup_button outer">
        <ul>
            <li>
                <a href="javascript:callProc();" class="gray large">생성</a>
            </li>
        </ul>
    </div>
    </div>
</div>
</body>
</html>