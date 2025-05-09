<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>주소찾기</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");
	var arg = p.window.dialogArguments;
	
	$(function() {
		//배열 선언				
		var initdata = {};
		initdata.Cfg = {SearchMode:smServerPaging, MergeSheet:0, Page:100, FrozenCol:0, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"Text",			Hidden:0,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"rn" },
 			{Header:"우편번호",			Type:"Text",			Hidden:0,	Width:100,				Align:"Center",	ColMerge:0,	SaveName:"zipcode", 			UpdateEdit:0 },
			{Header:"도로명주소",		Type:"Text",			Hidden:0,	Width:250,				Align:"Left",	ColMerge:0,	SaveName:"doro_full_addr", 		UpdateEdit:0 },
			{Header:"지번주소",			Type:"Text",			Hidden:0,	Width:300,				Align:"Left",	ColMerge:0,	SaveName:"jibun_addr", 			UpdateEdit:0 },
			{Header:"빌딩관리번호",		Type:"Text",			Hidden:1,	Width:100,				Align:"Center",	ColMerge:0,	SaveName:"building_manage_num", UpdateEdit:0 },
			{Header:"법정동주택명",		Type:"Text",			Hidden:1,	Width:100,				Align:"Center",	ColMerge:0,	SaveName:"addr_note", 			UpdateEdit:0 },
			{Header:"도로명",			Type:"Text",			Hidden:1,	Width:100,				Align:"Center",	ColMerge:0,	SaveName:"doro_addr", 			UpdateEdit:0 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();
	});
	
	$(function() {
        $("#searchAddress").bind("keyup",function(event){
			if( event.keyCode == 13){
		 		doAction("Search");
			}
		});
        
        $("#notFindAddrStatus").bind("click",function(event){
        	notFindAddrStatusChk();
		});
        
	    $('#zipCode').mask('000000', {reverse: true});
        
        $(".close").click(function() {
	    	p.self.close();
	    });
	});
	
	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": //조회
			//조회 조건 체크
			if( searchNameCheck($("#searchAddress").val())){
				var param = {"Param":"cmd=selectZipCodeList&defaultRow=100&"+$("#srchFrm").serialize()};
				sheet1.DoSearchPaging( "<%=jspPath%>/common/zipCodePopupRst.jsp", param );			
			}		
			break;
		}
    } 
	
	// 	조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			alertMessage(Code, Msg, StCode, StMsg);
			setSheetSize(sheet1);
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}

	function sheet1_OnClick(Row, Col){
		try{
			setAddr();
		} catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}
	
	// 주소 검색 시, 검색 단어 체크
	function searchNameCheck(search){
		
		// 1. 3자 이상
		if( search.length < 3){
			alert( "도로명주소나, 지번주소를 3자이상 입력하여 주십시오." );
			return false;
		}
		
		// 2. 특수문자 '-'이외에 입력 금지
		var re = /[~!@\#$%^&*\()\=+_']/gi;

	    if(re.test(search)){
	        alert("특수문자는 입력하실수 없습니다.");
	        return false;
	    }
	    
		// 3. 한글 무족건 포함
		var check = /[ㄱ-ㅎ|ㅏ-ㅣ|가-히]/;
		
		if(!check.test(search)){
			alert("도로명주소나, 지번주소의 한글을 1자 이상 입력하여 주십시오.");
			return false;
		}

		return true;
	}
	
	//도로명주소가 없을 경우 체크
	function notFindAddrStatusChk(){
		
		if( $("#notFindAddrStatus").is(":checked") ){
			//직접입력일 때 안내 메세지
			if( !confirm("도로명주소법에 의거하여, 도로명주소로 변경된 지번주소는 사용할 수 없습니다. 다만, 지번주소에 해당하는 도로명주소가 없는 경우에는 직접입력을 통해 진행 할 수 있습니다. 계속 진행하시겠습니까?") ){
				$("#notFindAddrStatus").attr("checked",false);
				return;
			}
		}
		
		//직접입력
		if( $("#notFindAddrStatus").is(":checked") ){
			//직업 입력 할 수 있게, 우편번호 readOnly 삭제
			$("#zipCode").val("");
			$("#zipCode").attr("readonly",false);
			$("#zipCode").removeClass();
			$("#doroFullAddr").val("");
		}
		//도로명주소 다시 사용
		else{
			$("#zipCode").val("");
			$("#zipCode").attr("readonly",true);
			$("#zipCode").addClass("readonly");
			$("#doroFullAddr").val("");
		}
	}	
	
	//2013-05-27 김장현 - 주소 부분에 세팅
	function setAddr(){ 
		//직접입력이 아닐 경우에만 주소 부분에 세팅
		
		if( !$("#notFindAddrStatus").is(":checked") ){
			//2013-05-27 김장현 - 팝업 주소창에서 상세주소까지 입력 하게 변경
			$("#zipCode").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "zipcode"));
			$("#doroFullAddr").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "doro_full_addr"));
			$("#doroAddr").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "doro_addr"));
			$("#addrNote").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "addr_note"));
		}else{
			alert("직접입력의 경우, 조회 내역을 사용 할 수 없습니다.\n조회 내역을 사용하시려면 직접입력 체크박스를 해제해주십시오.");
			return;
		}
	}
	
	function setValue(){
		//상세주소가 없을 수도 있기 때문에 상세주소 없이도 가능.
		/*
		var dtlAddr = document.all.dtlAddr.value;
		if( dtlAddr.length < 1 ){
			alert("상세주소를 입력하여 주십시오.");
			document.all.dtlAddr.focus();
		}
		*/
		
		var resDoroFullAddr = "";
		
		var resDoroAddr = $("#doroAddr").val();
		var resDtlAddr = $("#dtlAddr").val();
		var resAddrNote = $("#addrNote").val();
		var resZipCode = $("#zipCode").val();

		//직접입력
		if( $("#notFindAddrStatus").is(":checked") ){
			resDoroFullAddr = $("#dtlAddr").val();
			
			if( resZipCode == null || resZipCode == "" || resZipCode.length < 5){
				alert("우편번호를 입력하여 주십시오.");
				$("#zipCode").focus();
				return;
			}
			
			if( resDoroFullAddr == null || resDoroFullAddr == "" ){
				alert("주소를 입력하여 주십시오.");
				$("#dtlAddr").focus();
				return;
			}
			
		} else{
			//우편번호 및 도로명주소 체크
			var checkzipCode = $("#zipCode").val();
			var checkDoroAddr =	$("#doroFullAddr").val();
			if( checkDoroAddr.length < 1 || checkzipCode.length < 1 ){
				alert( "주소찾기 기능을 통해 주소를 검색 한 후, 도로명 주소를 선택하여 주십시오." );
				return;
			}
			
			/* 2013-05-27 - 김장현 도로명주소 표기법 안내 (참고 http://www.law.go.kr/lsEfInfoP.do?lsiSeq=135801#0000 )
			 - 도로명주소법 시행령 - [시행 2013.3.23] [대통령령 제24425호, 2013.3.23, 타법개정]
			 ① 도로명주소는 다음 각 호의 순서에 따라 표기한다.  <개정 2010.4.7>
			   1. 특별시·광역시·도·특별자치도(이하 "시·도"라 한다)의 이름
			   2. 시·군·자치구[「제주특별자치도 설치 및 국제자유도시 조성을 위한 특별법」 제15조제2항에 따른 행정시(이하 이 항에서 "행정시"라 한다)를 포함한다. 이하 "시·군·구"라 한다]의 이름
			   3. 행정구(자치구가 아닌 구를 말한다)·읍·면의 이름
			   4. 도로명
			   5. 건물번호
			   6. 상세주소(상세주소가 있는 경우에만 표기한다)
			   7. 참고항목: 도로명주소의 끝 부분에 괄호를 하고 그 괄호 안에 다음 각 목의 구분에 따른 사항을 표기할 수 있다.
			     가. 특별시·광역시와 시(행정시를 포함한다)의 동(洞) 지역에 있는 공동주택이 아닌 건물등: 법정동(法定洞)의 이름
			     나. 특별시·광역시와 시(행정시를 포함한다)의 동(洞) 지역에 있는 공동주택: 법정동(法定洞)의 이름과 건축물대장에 적혀 있는 공동주택의 이름. 이 경우 법정동의 이름과 공동주택의 이름 사이에는 쉼표를 넣어 표기한다.
			     다. 읍·면 지역에 있는 공동주택: 건축물대장에 적혀 있는 공동주택의 이름
			 ② 건물번호는 아라비아 숫자로 표기하며, 건물등이 지하에 있는 경우에는 건물번호 앞에 "지하"를 붙여서 표기한다.
			 ③ 제2항에서 규정한 사항 외에 건물번호의 구성에 필요한 사항은 안전행정부령으로 정한다.  <개정 2013.3.23>
			 ④ 상세주소는 동(棟)번호, 층(層)수, 호(號)수의 순서로 표기한다. 다만, 호수에 층수의 의미가 포함된 경우에는 층수를 표기하지 않을 수 있다.
			 ⑤ 건물번호와 상세주소를 구분하기 위하여 건물번호와 상세주소 사이에 쉼표를 넣어 표기한다. 
			 */
		
			resDoroFullAddr = resDoroAddr;
			
			
			//상세 주소가 있다면 구분을 위해 사이에 ', ' 문자열 삽입.
			if(resDtlAddr.length > 0 ){
				resDoroFullAddr += ", "+resDtlAddr;
			}
			
			//법정동 및 공동주택명이 있다면 구분을 위해 사이에 ' ' 문자열 삽입.
			if(resAddrNote.length > 0 ){
				resDoroFullAddr += " "+resAddrNote;
			}
		}
		
		
		
		var arrayList = new Array();
	    
	    arrayList[0] = resZipCode;
	    arrayList[1] = resDoroFullAddr;
	    arrayList[2] = '';
	    arrayList[3] = '';
	    
	    //p.window.returnValue = arrayList;
	    if(p.popReturnValue) p.popReturnValue(arrayList);
	    p.self.close();
	}	

</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>주소조회</li>
                <!--<li class="close"></li>-->
            </ul>
        </div>
        <div class="popup_main">
            <form id="srchFrm" name="srchFrm">
            	<input type="hidden" name="hangle_giha" value="지하" />
            	<input type="hidden" name="hangle_san" value="산" />
                <div class="outer">
                	<table>
                		<tr>
                			<td><span>* 검색방법</span></br>
							1. 지번주소의  <B>동(리)명+지번을 입력</B>해 주십시오. <B>예)</B> 반포동 112-4, 서초동 700, 덕동리 산90-1<br/>
							2. 도로명주소의  <B>도로명+건물번호를 입력</B>해 주십시오. <B>예)</B> 사평대로 84, 남부순환로 2406<br/>
							<span style="color:#D35572"><b>3. 도로명주소가 존재하지 않을 경우에만, 직접입력을 통해 주소를 입력 하십시오.</b></span>
                			</td>
                		</tr>
                	</table>
                </div>
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
                        <td>
                        	<span>주소</span>
                        	<input id="searchAddress" name ="searchAddress" type="text" class="text" style="width:300px;"/>
                        </td>
                        <td>
        					<input type="checkbox" id="notFindAddrStatus" name="notFindAddrStatus" style="vertical-align:middle;"/>직접입력
                        </td>
                        <td>
                            <a href="javascript:doAction('Search')" id="btnSearch" class="button">조회</a>
                        </td>
                    </tr>
                    </table>
                    </div>
                </div>
	        </form>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">주소조회</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
			<div class="outer" style="margin-top:10px;">
				<table border="0" cellpadding="0" cellspacing="0" class="default">
				    <colgroup>
				        <col width="17%" />
				        <col width="" />
				    </colgroup>
				    <tr>
				        <td>우편번호</td>
				        <td><input type="text" id="zipCode" name="zipCode" size="30" maxlength="7" class="readonly" readOnly/></td>    
				    </tr>
				    <tr>
				        <td>도로명주소</td>
				        <td><input type="text" id="doroFullAddr" name="doroFullAddr" size="70" class="readonly" readOnly/></td>    
				    </tr>
				    <tr> 
				        <td>상세주소</td>
				        <td><input type="text" id="dtlAddr" name="dtlAddr" size="70"/></td>    
				    </tr>
				    <input type="hidden" id="doroAddr" name="doroAddr" />
					<input type="hidden" id="addrNote" name="addrNote" />
				</table>
			</div>

	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <a href="javascript:setValue();" class="pink large">확인</a>
	                    <a href="javascript:p.self.close();" class="gray large">닫기</a>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>