<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title></title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>


<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");
	var workingYn = "";
	
	var sabun = p.popDialogArgument("sabun");
	var pSabuns = p.popDialogArgument("pSabuns")
	var empName = p.popDialogArgument("empName").replaceAll("*", "0");
	var arrName = p.popDialogArgument("arrName").replaceAll("*", "0");
	var sabunCnt = p.popDialogArgument("sabunCnt");
	var searchWorkYy = p.popDialogArgument("searchWorkYy");
	
	var rdTitle= "";
	var rdMrd = "";
	var rdParam1 = "";
	var rdParam2 = "";
	var rdParam3 = "";
	var rdParam4 = "";
	var rdParam5 = "";
	var rdParam6 = "";
	var rdParam7 = "";
	var rdParam8 = "";
	var rdParam9 = "";
	var rdParam10 = "";
	var rdParam11 = "";
	var rdParam12 = "";
	var rdParam13 = "";
	var rdParam14 = "";
	var rdParam15 = "";
	var rdParam16 = "";
	var rdParam17 = "";
	
	var arg = p.window.dialogArguments;
	
	if( arg != undefined ) {
		rdTitle         = arg["rdTitle"] ;
		rdMrd           = arg["rdMrd"] ;
		rdParam1		= arg["rdParam1"] ;
		rdParam2		= arg["rdParam2"] ;
		rdParam3		= arg["rdParam3"] ;
		rdParam4		= arg["rdParam4"] ;
		rdParam5		= arg["rdParam5"] ;
		rdParam6		= arg["rdParam6"] ;
		rdParam7		= arg["rdParam7"] ;
		rdParam8		= arg["rdParam8"] ;
		rdParam9		= arg["rdParam9"] ;
		rdParam10		= arg["rdParam10"] ;
		rdParam11		= arg["rdParam11"] ;
		rdParam12		= arg["rdParam12"] ;
		rdParam13		= arg["rdParam13"] ;
		rdParam14		= arg["rdParam14"] ;
		rdParam15		= arg["rdParam15"] ;
		rdParam16		= arg["rdParam16"] ;
		rdParam17		= arg["rdParam17"] ;
	}else{
		rdTitle 	 = p.popDialogArgument("rdTitle");
		rdMrd 		 = p.popDialogArgument("rdMrd");
		rdParam1	 = p.popDialogArgument("rdParam1");
		rdParam2	 = p.popDialogArgument("rdParam2");
		rdParam3 	 = p.popDialogArgument("rdParam3");
		rdParam4 	 = p.popDialogArgument("rdParam4");
		rdParam5 	 = p.popDialogArgument("rdParam5");
		rdParam6 	 = p.popDialogArgument("rdParam6");
		rdParam7 	 = p.popDialogArgument("rdParam7");
		rdParam8 	 = p.popDialogArgument("rdParam8");
		rdParam9 	 = p.popDialogArgument("rdParam9");
		rdParam10 	 = p.popDialogArgument("rdParam10");
		rdParam11 	 = p.popDialogArgument("rdParam11");
		rdParam12 	 = p.popDialogArgument("rdParam12");
		rdParam13 	 = p.popDialogArgument("rdParam13");
		rdParam14 	 = p.popDialogArgument("rdParam14");
		rdParam15 	 = p.popDialogArgument("rdParam15");
		rdParam16 	 = p.popDialogArgument("rdParam16");
		rdParam17 	 = p.popDialogArgument("rdParam17");
	}
	
	$(function() {
		$("#searchWorkYy").val(searchWorkYy);
		$("#rdMrd").val(rdMrd);
		
		var rtnval = ajaxCall("<%=jspPath%>/withHoldRcptSta_mig/rcptInvoker.jsp?cmd=onload", $("#srchFrm").serialize(), false);
		
		if(rtnval.fileExist == "N") {
			alert("양식이 존재하지않습니다. 담당자에게 문의하세요.\n(" + rdMrd + ")");
			p.self.close();
			return;
		} 
		
		if (rtnval == null || rtnval.downFileName == undefined || rtnval.downFileName == "" || rtnval.downFileSize == "0.0KB") {
			$("#fileName").val("");
			$("#fileDate").val(""); 
			$("#fileSize").val("");
		} else {
			$("#fileName").val(rtnval.downFileName);
			$("#fileDate").val(rtnval.downFileDate); 
			$("#fileSize").val(rtnval.downFileSize);	
		} 
		
        $(".close").click(function() {
	    	p.self.close();
	    });
	});

	/*Sheet Action*/
	function doAction(sAction) {
		$("#sPsabuns").val(pSabuns);
		$("#arrName").val(arrName);
		$("#ssabun").val(sabun);
		$("#empName").val(empName);
		$("#sabunCnt").val(sabunCnt);
		$("#rdTitle").val(rdTitle);
		$("#rdMrd").val(rdMrd);
		$("#rdParam1").val(rdParam1);
		$("#rdParam2").val(rdParam2);
		$("#rdParam3").val(rdParam3);
		$("#rdParam4").val(rdParam4);
		$("#rdParam5").val(rdParam5);
		$("#rdParam6").val(rdParam6);
		$("#rdParam7").val(rdParam7);
		$("#rdParam8").val(rdParam8);
		$("#rdParam9").val(rdParam9);
		$("#rdParam10").val(rdParam10);
		$("#rdParam11").val(rdParam11);
		$("#rdParam12").val(rdParam12);
		$("#rdParam13").val(rdParam13);
		$("#rdParam14").val(rdParam14);
		$("#rdParam15").val(rdParam15);
		$("#rdParam16").val(rdParam16);
		$("#rdParam17").val(rdParam17);
		$("#sprintOption").val($("#optionYn").val());
		$("#downfileName").val($("#fileName").val());
		
		switch (sAction) {
	        case "chk":
	            if ($("#fileName").val() != "") {
	        		if(!confirm("기존에 생성되었던 서버의 파일을 제거하고 새로 생성합니다.\n(" + $("#fileName").val() + ")\n계속 진행하시겠습니까?")) {
			            break;
	        		}
	        	}
	        	$("#fileName").val("");
			    $("#fileDate").val(""); 
			    $("#fileSize").val("");
			    
	        	chkDisk(ajaxCall("<%=jspPath%>/withHoldRcptSta_mig/rcptInvoker.jsp?cmd=CheckDisk", $("#srchFrm").serialize(), false));
			break;
			
	        case "cre":
	        	if(workingYn == "Y"){
	        		alert("파일생성이 진행중입니다.");
	        		return;
	        	}       	
        		var rtnData = ajaxCall("<%=jspPath%>/withHoldRcptSta_mig/rcptInvoker.jsp?cmd=creFile", $("#srchFrm").serialize(), true
	        			,function(){
		                    /* $("#progressCover").show(); */
		                    workingYn = "Y";
	        				timer_start();
		                }
		                ,function(rtnData){
		                    clearInterval(t1);
			        		workingYn = "N";
			    	    	tCounter = 0;

		                    $("#fileName").val(rtnData.downFileName);
			        		$("#fileDate").val(rtnData.downFileDate); 
			        		$("#fileSize").val(rtnData.downFileSize);
			        		
		                	if (rtnData.Result.Code > 0) {
				        		setProgressPercent(100);
				        		if(rtnData.downFileName.length > 0) {
				        			$("iframe").attr("src",'<%=jspPath%>/withHoldRcptSta_mig/rcptInvoker.jsp?cmd=downFile&downfileName='+$("#fileName").val()+'&searchWorkYy='+searchWorkYy);	
				        		}
		                	} else {
				        		setProgressPercent(0);
		                	}
		                }
				);
	        
	            break;
	        case "down":
	        	if($("#fileName").val().length == 0) {
	        		alert("생성된 파일이 없습니다.");
	        		return;
	        	}
	        	$("iframe").attr("src",'<%=jspPath%>/withHoldRcptSta_mig/rcptInvoker.jsp?cmd=downFile&downfileName='+$("#fileName").val()+'&searchWorkYy='+searchWorkYy);
	    		
	            break;
		}
	}

	function chkDisk(rtnData) {
		if(rtnData.usableSpace < rtnData.totFile) {
			if(confirm("생성파일 총예상용량이 디스크 사용가능용량보다 큽니다.\n생성파일 총예상용량 : "+rtnData.totFile+"KB\n디스크 사용가능용량 : "+rtnData.usableSpace+"KB\n진행하시겠습니까?")) {
				doAction("cre");
			}
		} else {
			doAction("cre");
		}
	}
	
	// 	조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			alertMessage(Code, Msg, StCode, StMsg);
		  	if(sheet1.RowCount() == 0) {
		    	//alert("대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.");
		  	}
		  	sheet1.FocusAfterProcess = false;
			setSheetSize(sheet1);
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}


	function sheet1_OnDblClick(Row, Col){
		try{
			returnFindUser(Row,Col);
		} catch(ex){
			alert("OnDblClick Event Error : " + ex);
		} finally{
			p.self.close();
		}
	}

	var t1;
	var tCounter = 0;
	var eachPercent = 100 / sabunCnt;
	function timer_start(){ //초기 설정함수
	    tCounter = 0; //설정
	    if($("#optionYn").val() == 'Y'){
	    	t1 = setInterval(Timer1,1000);	
	    } else {
	    	t1 = setInterval(Timer2,2000);
	    }
	}

	function Timer1(){
		
		tCounter = tCounter + eachPercent;
		if(tCounter > 99) {
			tCounter = 99;
		}
		setProgressPercent(tCounter);
	}
	
	function Timer2(){
		
		fileCountChk(ajaxCall("<%=jspPath%>/withHoldRcptSta_mig/rcptInvoker.jsp?cmd=cntChk&searchWorkYy="+searchWorkYy, "", false));
	}
	
	function fileCountChk(rtnData) {
		tCounter = rtnData.fileCnt * eachPercent;
	    setProgressPercent(tCounter);
	}
	
	// 프로시저 진행률 display
	function setProgressPercent(rtnval) {
		
	   /*  var width = Math.round((203-0) / (100-0) * value); */
	    var value = Math.round(rtnval);
	    if(value > 100) {
	    	value = 100;
	    }
		$("#progressRate").text(value);
		$("#progressBar").width(value+"%");

		progress = value;
		
	    if(value == 100) {
	    	clearInterval(t1);
	    	tCounter = 0;
	    }
	}
</script>

</head>
<body class="bodywrap">
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%; z-index:99;"></div>
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>다운로드</li>
            </ul>
        </div>
        <div class="popup_main">
            <form id="srchFrm" name="srchFrm">
                <input type="hidden" id="ssabun" name="ssabun"/>
                <input type="hidden" id="sPsabuns" name="sPsabuns"/>
                <input type="hidden" id="sprintOption" name="sprintOption" />
                <input type="hidden" id="downfileName" name="downfileName" />
                <input type="hidden" id="empName" name="empName" />
                <input type="hidden" id="sabunCnt" name="sabunCnt" />
                <input type="hidden" id="rdTitle" name="rdTitle" />
                <input type="hidden" id="rdMrd" name="rdMrd" />
                <input type="hidden" id="rdParam1" name="rdParam1" />
                <input type="hidden" id="rdParam2" name="rdParam2" />
                <input type="hidden" id="rdParam3" name="rdParam3" />
                <input type="hidden" id="rdParam4" name="rdParam4" />
                <input type="hidden" id="rdParam5" name="rdParam5" />
                <input type="hidden" id="rdParam6" name="rdParam6" />
                <input type="hidden" id="rdParam7" name="rdParam7" />
                <input type="hidden" id="rdParam8" name="rdParam8" />
                <input type="hidden" id="rdParam9" name="rdParam9" />
                <input type="hidden" id="rdParam10" name="rdParam10" />
                <input type="hidden" id="rdParam11" name="rdParam11" />
                <input type="hidden" id="rdParam12" name="rdParam12" />
                <input type="hidden" id="rdParam13" name="rdParam13" />
                <input type="hidden" id="rdParam14" name="rdParam14" />
                <input type="hidden" id="rdParam15" name="rdParam15" />
                <input type="hidden" id="rdParam16" name="rdParam16" />
                <input type="hidden" id="rdParam17" name="rdParam17" />
                <input type="hidden" id="arrName" name="arrName" />
                <input type="hidden" id="searchWorkYy" name="searchWorkYy" />
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
                        <td> 
                            <span> 파일명 : </span> 
                        	<select id="nameRule1" name ="nameRule1" onChange="" class="box">
	                            <option value="1" selected>담당자사번</option>
	                            <option value="2">대상자사번</option>
	                            <option value="3">대상자성명</option>
	                            <option value="4">생성일시</option>
	                            <option value="5">선택안함</option>
                        	</select> 
                        	<span>_</span><select id="nameRule2" name ="nameRule2" onChange="" class="box">
	                            <option value="1">담당자사번</option>
	                            <option value="2"selected>대상자사번</option>
	                            <option value="3">대상자성명</option>
	                            <option value="4">생성일시</option>
	                            <option value="5">선택안함</option>
                        	</select> 
                        	<span>_</span><select id="nameRule3" name ="nameRule3" onChange="" class="box">
	                            <option value="1">담당자사번</option>
	                            <option value="2">대상자사번</option>
	                            <option value="3"selected>대상자성명</option>
	                            <option value="4">생성일시</option>
	                            <option value="5">선택안함</option>
                        	</select> 
                        	<span>_</span><select id="nameRule4" name ="nameRule4" onChange="" class="box">
	                            <option value="1">담당자사번</option>
	                            <option value="2">대상자사번</option>
	                            <option value="3">대상자성명</option>
	                            <option value="4"selected>생성일시</option>
	                            <option value="5">선택안함</option>
                        	</select> 
                        	<span>.</span><select id="optionYn" name ="optionYn" class="box">
	                            <option value="Y" selected>PDF (통합 PDF파일 1부)</option>
	                            <option value="N" >ZIP (개별PDF 압축파일 1부)</option>
                        	</select>
                        </td>
                        
                    	<td>
                            <a href="javascript:doAction('chk')" id="btnSearch" class="button">파일생성</a>
                        </td> 
                    </tr>
                    
                    </table>
                    </div>
                </div>

	        </form>
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">생성결과</li>
					</ul>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="default">
					<colgroup>
						<col width="10%" />
						<col width="35%" />
						<col width="10%" />
						<col width="20%" />
						<col width="10%" />
						<col width="15%" />
					</colgroup>
					<tr>
						<th>진행률</th>
						<td colspan="4"><div class="progressbar"><div id="progressBar"></div></div></td>
						<td class="center"><span id="progressRate" class="tPink strong"></span> %</td>
					</tr>
					<tr>
					
						<th>파일명</th>
						<td>
							<input type="text" id="fileName" name="fileName" class="text readonly" value="" style="width:100%" readonly />
						</td>
					
						<th>생성일시</th>
						<td>
							<input type="text" id="fileDate" name="fileDate" class="text center readonly" value="" style="width:100%" readonly />
						</td>
					
						<th>크기</th>
						<td>
							<input type="text" id="fileSize" name="fileSize" class="text center readonly" value="" style="width:100%" readonly />
						</td>
					</tr>
					<tr>
						<td colspan=5>
							<font color='blue'>※ 로그인한 담당자의 최근 생성파일이 표기됩니다.</font>
						</td>
						<td >
							<a href="javascript:doAction('down')" id="btnSearch" class="button">다운로드</a>
						</td>
					</tr>
				</table>
			</div>
			

	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <a href="javascript:p.self.close();" class="gray large">닫기</a>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
    <iframe id="FileDownloadFrame" src="" frameborder="0" scrolling="no" width="0" height="0" style="display:none"></iframe>
</body>
</html>