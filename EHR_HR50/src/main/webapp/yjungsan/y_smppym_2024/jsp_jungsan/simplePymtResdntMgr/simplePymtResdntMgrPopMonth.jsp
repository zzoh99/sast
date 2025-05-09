<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>비거주자사업기타소득 생성</title>
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
            var workMm 	  = "";
            var searchGb  = "";
            var halfType  = "";
            var businessPlace  = "";

            workYy 	  	  = p.popDialogArgument("workYy");
            workMm 	  	  = p.popDialogArgument("workMm");
            searchGb	  = p.popDialogArgument("searchGb");
            halfType 	  = p.popDialogArgument("halfType");
            businessPlace = p.popDialogArgument("businessPlace");

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
            //사업장
            $("#businessPlace").val(businessPlace);
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
            //사업장
            $("#businessPlace").val(arg["businessPlace"]);
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

		// 소득구분코드 (근로 : 77 / 사업 : 50 / 비거주자 : 49 / 거주자기타 : 55)
		var incomeType = "55";
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

        //2021.07.26
//         if(workYy == "2021" && halfType == "2"){
//         	//2021년 상반기 이후  P_CPN_SMPPYM_EMP_2021 호출 
<%--         	var data = ajaxCall("<%=jspPath%>/simplePymtResdntMgr/simplePymtResdntMgrRst.jsp?cmd=P_CPN_SMPPYM_EMP_2021",$("#sheet1Form").serialize(),false); --%>
//         }else if(workYy > "2021"){
//         	//2022년 부터  P_CPN_SMPPYM_EMP_2021 호출
<%--         	var data = ajaxCall("<%=jspPath%>/simplePymtResdntMgr/simplePymtResdntMgrRst.jsp?cmd=P_CPN_SMPPYM_EMP_2021",$("#sheet1Form").serialize(),false); --%>
//         }else{
//             // 자료생성
<%--         	var data = ajaxCall("<%=jspPath%>/simplePymtResdntMgr/simplePymtResdntMgrRst.jsp?cmd=P_CPN_SMPPYM_EMP",$("#sheet1Form").serialize(),false); --%>
//         }
        var data = ajaxCall("<%=jspPath%>/simplePymtResdntMgr/simplePymtResdntMgrMonthRst.jsp?cmd=P_CPN_SMPPYM_EMP_2024",$("#sheet1Form").serialize(),false);
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
            <input id="businessPlace" name="businessPlace" type="hidden" value="" />
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
				<table class="table w100p" style="margin-top: 5px;">
					<colgroup>
						<col width="20%" />
						<col width="60%" />
						<col width="20%" />
					</colgroup>
					<tr>
						<th style="font-size: 15px; text-align: center;" rowspan="2" >생성 기준</th>
						<td style="font-size: 15px;">지급년월</td>
						<td><input style="margin-left: 35px;" type="radio" name="rdBtnCalcType" value="1" checked /></td>
						
					</tr>
					<tr>
						<td style="font-size: 15px;">귀속년월</td>
						<td><input style="margin-left: 35px;" type="radio" name="rdBtnCalcType" value="2"/></td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
	<tr>
		<td class="">
			<div class="inner">
				<table class="table w100p" id="htmlTable" style="margin-top: 5px;">
					<colgroup>
						<col width="20%" />
						<col width="60%" />
						<col width="20%" />
					</colgroup>
					<tr>
						<th style="font-size: 15px; text-align: center;" rowspan="3" >생성 방식</th>
						<td style="font-size: 15px;">기존 데이터 삭제 후 재생성</td>
						<td><input style="margin-left: 35px;" type="radio" id="rdBtn" name="rdBtn" value="01" checked /></td>
						
					</tr>
					<tr>
						<td style="font-size: 15px;">기존 데이터 외 변화 없이 생성</td>
						<td><input style="margin-left: 35px;" type="radio" id="rdBtn" name="rdBtn" value="02"/></td>
					</tr>
                    <tr>
                       <td style="font-size: 13px;" colspan="2" align="left"><span style="color: blue"> 마감된 데이터는 재생성되지 않으며 마감해제 필요</span></td>
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