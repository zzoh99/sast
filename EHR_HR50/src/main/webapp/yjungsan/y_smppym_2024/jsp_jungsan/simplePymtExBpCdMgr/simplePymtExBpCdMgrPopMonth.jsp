<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>전반기 예외관리 대상자 복사</title>
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

    	var incomeTypeList = "";		//소득구분
    	
    	incomeTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM=<%=curSysYear%><%=curSysMon%>","YEA003"), "");
    	
		$("#searchFromIncomeType").html(incomeTypeList[2]);
		$("#searchToIncomeType").html(incomeTypeList[2]);
        
        if( arg != undefined ) {
            
            $("#searchToWorkYy").val(arg["workYy"]);
        	$("#searchToSendType").val(arg["sendType"]);
        	$("#searchToHalfType").val(arg["halfType"]);
        	$("#searchToIncomeType").val(arg["incomeType"]);
        	
        }else{            
        	
        	var workYy 	  = "";
            var sendType  = "";
            var halfType  = "";
            var incomeType  = "";
			
            workYy 	  		= p.popDialogArgument("workYy");
            sendType 	  	= p.popDialogArgument("sendType");
            halfType 	  	= p.popDialogArgument("halfType");
            incomeType 	  	= p.popDialogArgument("incomeType");
			
        	$("#searchToWorkYy").val(workYy);
        	$("#searchToSendType").val(sendType);
        	$("#searchToHalfType").val(halfType);
        	$("#searchToIncomeType").val(incomeType);
        }
        
        //상반기(1)인 경우 작년 하반기, 하반기(2)인 경우 당해년도 상반기
        if($("#searchToHalfType").val() == "1"){
        	$("#searchFromWorkYy").val(parseInt($("#searchToWorkYy").val())-1) ;
        	$("#searchFromHalfType").val("2");	
        }else{
        	$("#searchFromWorkYy").val($("#searchToWorkYy").val());
        	$("#searchFromHalfType").val("1");
        }
        
		$("#searchFromIncomeType").change(function(){
			$("#searchToIncomeType").val($("#searchFromIncomeType").val());
		});
		$("#searchToIncomeType").change(function(){
			$("#searchFromIncomeType").val($("#searchToIncomeType").val());
		});
        
    });
    
    
	// 복사 프로시저
	function callProc() {
		
		var delYn = "";
		var text = "";
		
		// 삭제여부
		if($("input:radio[name='rdBtn']").filter("input[value='Y']").attr("checked") == "checked"){
			$("#delYn").val("Y");
			text = $("#searchToWorkYy").val()+"년 기존자료를 삭제 후 재생성합니다.";
		}else{
			$("#delYn").val("N");
			text = $("#searchToWorkYy").val()+"년 기존자료 외 데이터만 생성합니다.";
		}
		
		if(confirm(text)){
			var data = ajaxCall("<%=jspPath%>/simplePymtExBpCdMgr/simplePymtExBpCdMgrRst.jsp?cmd=P_CPN_SMPPYM_EX_BP_COPY",$("#mySheetForm").serialize(),false);
			 
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

	}

</script>
</head>
<body class="bodywrap">
    <div class="wrapper popup_scroll">
		<form id="mySheetForm" name="mySheetForm">
			<input id="delYn" name="delYn" type="hidden" value="" />
        <div class="popup_main">

    <table border="0" cellspacing="0" cellpadding="0" class="sheet_main" style="margin-top: 40px;">
	<tr>
		<td class="">
			<div class="inner">
				<table class="table w100p" id="htmlTable">
					<colgroup>
						<col width="%" />
					</colgroup>
					<tr>
						<th style="text-align: center; font-size: 20px; font-weight: bold">전반기 예외관리 대상자 복사
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
						<col width="30%" />
						<col width="35%" />
						<col width="35%" />
					</colgroup>
					<tr>
						<th style="font-size: 15px; text-align: center;" rowspan="2" >복사 기준</th>
						<td><span>년도</span>
							<input id="searchFromWorkYy" name ="searchFromWorkYy" type="text" class="text" maxlength="4" style= "width:40px; padding-left: 10px;"/>
						</td>
						<td><span>반기구분</span>
							<select id="searchFromHalfType" name="searchFromHalfType" class="box">
					            <option value="1">상반기</option>
					            <option value="2">하반기</option>
					        </select>
						</td>
					</tr>
					<tr>
						<td><span>신고구분</span>
							<select id="searchFromSendType" name ="searchFromSendType" class="box">
									<option value="1">정기</option>
									<option value="2">수정</option>
							</select> 
						</td>
						<td><span>소득구분</span>
							<select id="searchFromIncomeType" name ="searchFromIncomeType" class="box"></select> 
						</td>
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
						<col width="30%" />
						<col width="35%" />
						<col width="35%" />
					</colgroup>
					<tr>
						<th style="font-size: 15px; text-align: center;" rowspan="2" >복사 대상</th>
						<td><span>년도</span>
							<input id="searchToWorkYy" name ="searchToWorkYy" type="text" class="text" maxlength="4" style= "width:40px; padding-left: 10px;"/>
						</td>
						<td><span>반기구분</span>
							<select id="searchToHalfType" name="searchToHalfType" class="box">
					            <option value="1">상반기</option>
					            <option value="2">하반기</option>
					        </select>
						</td>
					</tr>
					<tr>
						<td><span>신고구분</span>
							<select id="searchToSendType" name ="searchToSendType" class="box">
									<option value="1">정기</option>
									<option value="2">수정</option>
							</select> 
						</td>
						<td><span>소득구분</span>
							<select id="searchToIncomeType" name ="searchToIncomeType" class="box"></select> 
						</td>
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
						<col width="30%" />
						<col width="55%" />
						<col width="15%" />
					</colgroup>
					<tr>
						<th style="font-size: 15px; text-align: center;" rowspan="2" >생성 방식</th>
						<td>기존 데이터 삭제 후 재생성</td>
						<td><input style="margin-left: 25px;" type="radio" id="rdBtn" name="rdBtn" value="Y" checked /></td>
						
					</tr>
					<tr>
						<td>기존 데이터 외 변화 없이 생성</td>
						<td><input style="margin-left: 25px;" type="radio" id="rdBtn" name="rdBtn" value="N"/></td>
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
						<col width="%" />
					</colgroup>
					<tr>
						<th>
						 <font color='red'>대상년도, 분기에 같은 소득구분이 2개이상 있는 분들은 따로 등록해주시기 바랍니다.</font>
						</th>
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
    </form>
</div>
</body>
</html>