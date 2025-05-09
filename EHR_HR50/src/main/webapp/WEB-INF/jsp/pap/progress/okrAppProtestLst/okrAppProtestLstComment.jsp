<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<title><tit:txt mid='2023082801369' mdef='이의제기'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var authPgTemp="${authPg}";
	var authPg1st="";
	var authPg2nd="";
	var authPg3rd="";
	var pGubun = "";
	var memo1stValue = "";
	var memo2ndValue = "";
	var memo3rdValue = "";
	var saveYn = "N";
	
	$(function() {
		
		$(".close, #close").click(function() {
			p.self.close();
		});

		var arg = p.popDialogArgumentAll();
		if( arg != undefined ) {
			//변경된 데이터가 있는지 체크하기 위함.
			memo1stValue = arg["memo1st"];
			memo2ndValue = arg["memo2nd"];
			memo3rdValue = arg["memo3rd"];
			
			//값 세팅
			$("#searchAppraisalCd").val(arg["searchAppraisalCd"]);
			$("#searchSabun").val(arg["searchSabun"]);
			$("#searchAppOrgCd").val(arg["searchAppOrgCd"]);
			$("#fbStatusCd").val(arg["fbStatusCd"]);
			$("#memo1st").val(arg["memo1st"]);
			$("#feedback1st").val(arg["feedback1st"]);
			$("#fileSeq1st").val(arg["fileSeq1st"]);
			$("#memo2nd").val(arg["memo2nd"]);
			$("#feedback2nd").val(arg["feedback2nd"]);
			$("#fileSeq2nd").val(arg["fileSeq2nd"]);
			$("#memo3rd").val(arg["memo3rd"]);
			$("#feedback3rd").val(arg["feedback3rd"]);
			$("#fileSeq3rd").val(arg["fileSeq3rd"]);
			$("#adminCheck").val(arg["adminCheck"]);
			$("#feedback1stSabun").val(arg["feedback1stSabun"]);
			$("#feedback2ndSabun").val(arg["feedback2ndSabun"]);
			$("#feedback3rdSabun").val(arg["feedback3rdSabun"]);
		}
		
		//초기 이의제기 신청 시, 다른 입력부분에 대해서는 입력되지 않도록 화면 컨트롤
		if($("#fbStatusCd").val() == "") {
			authPg1st = "A";
			$("#memo1st").attr("readonly",false).removeClass("readonly");
		}
		
		$("#memo1st").attr("readonly",true).addClass("readonly");
		$("#feedback1st").attr("readonly",true).addClass("readonly");
		$('#btn1st').bind('click', false);
		$("#memo2nd").attr("readonly",true).addClass("readonly");
		$("#feedback2nd").attr("readonly",true).addClass("readonly");
		$('#btn2nd').bind('click', false);
		$('#btn2nd').bind('useHandCursor', false);
		$("#memo3rd").attr("readonly",true).addClass("readonly");
		$("#feedback3rd").attr("readonly",true).addClass("readonly");
		$('#btn3rd').bind('click', false);
		
		//첨부후에 저장만 한 경우에는 첨부한 내용이 있는지확인을 위해서 다운로드로 변경해준다.
		//1차 첨부파일 체크
		if($("#fileSeq1st").val() != ""){
			$("#file1stbtn > a").text("<tit:txt mid='download' mdef='다운로드'/>");
			$('#btn1st').unbind('click', false);
			authPg1st = "R";
		}
		
		//2차 첨부파일 체크
		if($("#fileSeq2nd").val() != ""){
			$("#file2ndbtn > a").text("<tit:txt mid='download' mdef='다운로드'/>");
			$('#btn2nd').unbind('click', false);
			authPg2nd = "R";
		}
		
		//3차 첨부파일 체크
		if($("#fileSeq3rd").val() != ""){
			$("#file3rdbtn > a").text("<tit:txt mid='download' mdef='다운로드'/>");
			$('#btn3rd').unbind('click', false);
			authPg3rd = "R";
		}
		
		//최초시작인 경우
		//평가자 또는 관리자인 경우에만 활성화 되도록 작업
		if($("#adminCheck").val() == "user") {
			if($("#fbStatusCd").val() == "") {
				$("#memo1st").attr("readonly",false).removeClass("readonly");
				$('#btn1st').unbind('click', false);
			}
			
			//1차 피드백까지 입력한 경우 2차 이의제기 및 첨부파일에 대한 활성화 처리
			if($("#fbStatusCd").val() == "13"){
				$("#memo2nd").attr("readonly",false).removeClass("readonly");
				$('#btn2nd').unbind('click', false);
				authPg2nd = "A";
			}
			
			//2차 피드백까지 입력한 경우 3차 이의제기 및 첨부파일에 대한 활성화 처리
			if($("#fbStatusCd").val() == "23"){
				$("#memo3rd").attr("readonly",false).removeClass("readonly");
				$('#btn3rd').unbind('click', false);
				authPg3rd  = "A";
			}
		
			//평가자 또는 관리자인 경우에만 활성화 되도록 작업
		} else if($("#adminCheck").val() == "admin") {
			//1차 이의제기를 입력 후, 피드백 등록시, 입력란 활성화처리
			if($("#fbStatusCd").val() == "11"){
				$("#feedback1st").attr("readonly",false).removeClass("readonly");
				$("#feedback1stSabun").val("${ssnSabun}");
			}

			//2차 이의제기를 입력 후, 피드백 등록시, 입력란 활성화처리
			if($("#fbStatusCd").val() == "21"){
				$("#feedback2nd").attr("readonly",false).removeClass("readonly");
				$("#feedback2ndSabun").val("${ssnSabun}");
			}

			//3차 이의제기를 입력 후, 피드백 등록시, 입력란 활성화처리
			if($("#fbStatusCd").val() == "31"){
				$("#feedback3rd").attr("readonly",false).removeClass("readonly");
				$("#feedback3rdSabun").val("${ssnSabun}");
			}
		}
		
		//이의신청기간 등 체크 후에 버튼 활성화 처리
		if(arg['saveBtnYn'] == 'N'){
			$("#btnSave").hide();
		}
		
		//평가자의 경우 1,2,3차피드백이 완료 되면 버튼 숨김처리
		if( arg['adminCheck'] == "admin" ) {
			if( $("#fbStatusCd").val() == "13" || $("#fbStatusCd").val() == "23" || $("#fbStatusCd").val() == "99" ) {
				$("#btnComplate").hide();
			}
		} else { //일반 이의제기 등록자인 경우에는 이의제기 신청한 경우에는 신청 버튼 보이지 않게 숨김처리
			if(arg['complateBtnYn'] == 'N'){ 
				$("#btnComplate").hide();
			}
		}
		//loadData();
	});

	/* function loadData() {
		var data = ajaxCall("${ctx}/OkrAppProtestLst.do?cmd=getOkrAppProtestCommentList", $("#srchFrm").serialize(), false);
		if (data.DATA != null) {
			$("#memo1st").val(data.DATA.memo1st);
			$("#feedback1st").val(data.DATA.feedback1st);
			$("#fileSeq1st").val(data.DATA.fileSeq1st);
			$("#memo2nd").val(data.DATA.memo2nd);
			$("#feedback2nd").val(data.DATA.feedback2nd);
			$("#fileSeq2nd").val(data.DATA.fileSeq2nd);
			$("#memo3rd").val(data.DATA.memo3rd);
			$("#feedback3rd").val(data.DATA.feedback3rd);
			$("#fileSeq3rd").val(data.DATA.fileSeq3rd);
		}
	} */
	
	function chkVal(){
		//1차 이의제기 내용 및 첨부파일 널값 체크
		if( ($("#memo1st").val().trim() == "" || $("#fileSeq1st").val().trim() == "") ){
			alert("<msg:txt mid='2023082801381' mdef='1차 이의제기내용 및 첨부파일을 등록 해주세요.'/>");
			$("#protestMemoMbo").focus();
			return false;
		}
		
		//1차 이의제기를 신청한 경우 피드백에 대한 널값 체크
		if( $("#fbStatusCd").val().trim() == "11" && $("#feedback1st").val().trim() == "" ){
			alert("<msg:txt mid='2023082801378' mdef='1차 피드백을 입력 해주세요.'/>");
			$("#feedback1st").focus();
			return false;
		}
		
		//2차 이의제기 내용 및 첨부파일 널값 체크 - 1차 피드백을 완료한 경우에만 체크됨.
		if( $("#fbStatusCd").val().trim() == "13" && ($("#memo2nd").val().trim() == "" || $("#fileSeq2nd").val().trim() == "") ) {
			alert("<msg:txt mid='2023082801380' mdef='2차 이의제기내용 및 첨부파일을 등록 해주세요.'/>");
			$("#memo2nd").focus();
			return false;
		}
		
		//2차 이의제기를 신청한 경우 피드백에 대한 널값 체크
		if( $("#fbStatusCd").val().trim() == "21" && $("#feedback2nd").val().trim() == "" ){
			alert("<msg:txt mid='2023082801377' mdef='2차 피드백을 입력 해주세요.'/>");
			$("#feedback2nd").focus();
			return false;
		}
		
		//3차 이의제기 내용 및 첨부파일 널값 체크 - 2차 피드백을 완료한 경우에만 체크됨.
		if( $("#fbStatusCd").val().trim() == "23" && ($("#memo3rd").val().trim() == "" || $("#fileSeq3rd").val().trim() == "") ) {
			alert("<msg:txt mid='2023082801379' mdef='3차 이의제기내용 및 첨부파일을 등록 해주세요.'/>");
			$("#memo3rd").focus();
			return false;
		}
		
		//3차 이의제기를 신청한 경우 피드백에 대한 널값 체크
		if( $("#fbStatusCd").val().trim() == "31" && $("#feedback3rd").val().trim() == "" ){
			alert("<msg:txt mid='2023082801376' mdef='3차 피드백을 입력 해주세요.'/>");
			$("#feedback3rd").focus();
			return false;
		}
		
		return true;
	}

	function setValue() {

		//필수값 체크
		if(!chkVal()) return;
		
		if(!confirm("<msg:txt mid='confirmSave' mdef='저장하시겠습니까?'/>"))	return;

		var data = ajaxCall("${ctx}/OkrAppProtestLst.do?cmd=saveOkrAppProtestLstComment",$("#srchFrm").serialize(),false);
		if(data.Result.Code == -1) {
			alert(data.Result.Message);
		} else {
			var rv = new Array();
			rv["Code"] = data.Result.Code;
			alert("<msg:txt mid='109987' mdef='저장되었습니다.'/>");
			
			saveYn = "Y";
		}
	}
	
	function setComplate() {
		//필수값 체크
		if(saveYn == "N"){
			if(!chkVal()) return;
			
			//피평가자인경우 저장되지 않았을 경우 체크 해준다.
			if($("#fbStatusCd").val() == "") {
				if(memo1stValue != $("#memo1st").val()) {
					alert("<msg:txt mid='2023082801384' mdef='1차 이의제기 저장 후 신청해주세요.'/>");
					return;
				}
			}else if($("#fbStatusCd").val() == "13") {
				if(memo2ndValue != $("#memo2nd").val()) {
					alert("<msg:txt mid='2023082801383' mdef='2차 이의제기 저장 후 신청해주세요.'/>");
					return;
				}
			}else if($("#fbStatusCd").val() == "23") {
				if(memo3rdValue != $("#memo3rd").val()) {
					alert("<msg:txt mid='2023082801382' mdef='3차 이의제기 저장 후 신청해주세요.'/>");
					return;
				}
			}
		}
		
		if(!confirm("<msg:txt mid='2023082801385' mdef='신청하시겠습니까?\n신청후에는 변경이 불가능합니다.'/>"))	return;

		//이의제기 신청과 피드백에 대한 차수별 상태
		if($("#fbStatusCd").val() == "") {
			$("#fbStatusCd").val("11");
		} else if($("#fbStatusCd").val() == "11") {
			$("#fbStatusCd").val("13");
		} else if($("#fbStatusCd").val() == "13") {
			$("#fbStatusCd").val("21");
		} else if($("#fbStatusCd").val() == "21") {
			$("#fbStatusCd").val("23");
		} else if($("#fbStatusCd").val() == "23") {
			$("#fbStatusCd").val("31");
		} else if($("#fbStatusCd").val() == "31") {
			$("#fbStatusCd").val("99");
		}
		
		var data = ajaxCall("${ctx}/OkrAppProtestLst.do?cmd=saveOkrAppProtestLstStatus",$("#srchFrm").serialize(),false);
		if(data.Result.Code == -1) {
			alert(data.Result.Message);
		} else {
			var rv = new Array();
			rv["Code"] = data.Result.Code;
			alert("<msg:txt mid='alertApplicationOk' mdef='신청되었습니다.'/>");
			p.popReturnValue(rv);
			p.window.close();
		}
	}

	// 첨부파일 등록	
	function attachFile(seq){
		if(!isPopup()) {return;}

		var param = [];
		if( seq == '1') {
			pGubun = "searchFileSeq1st";
			param["fileSeq"] = $("#fileSeq1st").val();
			authPgTemp = authPg1st;
		} else if(seq == '2') {
			pGubun = "searchFileSeq2nd";
			param["fileSeq"] = $("#fileSeq2nd").val();
			authPgTemp = authPg2nd;
		} else {
			pGubun = "searchFileSeq3rd";
			param["fileSeq"] = $("#fileSeq3rd").val();
			authPgTemp = authPg3rd;
		}
			
		var win = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=papProtest", param, "740","420");
	}
	
	//팝업 콜백 함수. 	
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "searchFileSeq1st") {
			if(rv["fileCheck"] == "exist"){
				$("#file1stbtn > a").text("<tit:txt mid='download' mdef='다운로드'/>");
				$("#fileSeq1st").val(rv["fileSeq"]);
			}else{
				$("#file1stbtn > a").text("<tit:txt mid='104241' mdef='첨부'/>");
				$("#fileSeq1st").val("");
			}
		}else if(pGubun == "searchFileSeq2nd") {
			if(rv["fileCheck"] == "exist"){
				$("#file2ndbtn > a").text("<tit:txt mid='download' mdef='다운로드'/>");
				$("#fileSeq2nd").val(rv["fileSeq"]);
			}else{
				$("#file2ndbtn > a").text("<tit:txt mid='104241' mdef='첨부'/>");
				$("#fileSeq2nd").val("");
			}
		} else {
			if(rv["fileCheck"] == "exist"){
				$("#file3rdbtn > a").text("<tit:txt mid='download' mdef='다운로드'/>");
				$("#fileSeq3rd").val(rv["fileSeq"]);
			}else{
				$("#file3rdbtn > a").text("<tit:txt mid='104241' mdef='첨부'/>");
				$("#fileSeq3rd").val("");
			}
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='2023082801369' mdef='이의제기'/></li>
		<li class="close"></li>
	</ul>
	</div>
	<div class="popup_main">
		<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="sStatus"					name="sStatus"  value="U" />
		<input type="hidden" id="searchAppraisalCd"			name="searchAppraisalCd" />
		<input type="hidden" id="searchSabun"				name="searchSabun" />
		<input type="hidden" id="searchAppOrgCd"			name="searchAppOrgCd" />
		<input type="hidden" id="fbStatusCd"				name="fbStatusCd" />
		<input type="hidden" id="s_SAVENAME"				name="s_SAVENAME" />
		<input type="hidden" id="adminCheck"				name="adminCheck" />
		<input type="hidden" id="feedback1stSabun"			name="feedback1stSabun" />
		<input type="hidden" id="feedback2ndSabun"			name="feedback2ndSabun" />
		<input type="hidden" id="feedback3rdSabun"			name="feedback3rdSabun" />

		<!-- 첨부파일 -->
		<input type="hidden" id="fileSeq1st" name="fileSeq1st" />	
		<input type="hidden" id="fileSeq2nd" name="fileSeq2nd" />	
		<input type="hidden" id="fileSeq3rd" name="fileSeq3rd" />	
		
		<table class="table">
			<tbody>
				<colgroup>
					<col width="7%" />
					<col width="39%" />
					<col width="39%" />
					<col width="15%" />
				</colgroup>
				<tr>
					<th style="background-color: #bbdefb;"> <tit:txt mid='112300' mdef='차수'/> </th>
					<th style="background-color: #bbdefb; text-align:center;"> <tit:txt mid='2023082801369' mdef='이의제기'/> </th>
					<th style="background-color: #bbdefb; text-align:center;"> <tit:txt mid='2023082801370' mdef='피드백'/> </th>
					<th style="background-color: #bbdefb; text-align:center;"> *<tit:txt mid='uploadFile' mdef='첨부파일'/> </th>
				</tr>
				<tr>
					<td> <tit:txt mid='113455' mdef='1차'/> </td>
					<td>
						<textarea id="memo1st" name="memo1st" rows="4" class="w100p"></textarea>
					</td>
					<td>
						<textarea id="feedback1st" name="feedback1st" rows="4" class="w100p"></textarea>
					</td>
					<td style="text-align:center;">
						<span id="file1stbtn"><btn:a href="javascript:attachFile('1');" css="basic" mid='attachFile' mdef="첨부" id="btn1st" style="background-color: #bbdefb;"/></span>
					</td>
				</tr>
				<tr>
					<td> <tit:txt mid='113807' mdef='2차'/> </td>
					<td>
						<textarea id="memo2nd" name="memo2nd" rows="4" class="w100p"></textarea>
					</td>
					<td>
						<textarea id="feedback2nd" name="feedback2nd" rows="4" class="w100p"></textarea>
					</td>
					<td style="text-align:center;">
						<span id="file2ndbtn"><btn:a href="javascript:attachFile('2');" css="basic" mid='attachFile' mdef="첨부" id="btn2nd" style="background-color: #bbdefb;"/></span>
					</td>
				</tr>
				<tr>
					<td> <tit:txt mid='112735' mdef='3차'/> </td>
					<td>
						<textarea id="memo3rd" name="memo3rd" rows="4" class="w100p"></textarea>
					</td>
					<td>
						<textarea id="feedback3rd" name="feedback3rd" rows="4" class="w100p"></textarea>
					</td>
					<td style="text-align:center;">
						<span id="file3rdbtn"><btn:a href="javascript:attachFile('3');" css="basic" mid='attachFile' mdef="첨부" id="btn3rd" style="background-color: #bbdefb;"/></span>
					</td>
				</tr>
			</tbody>
		</table>
		</form>
		
		<div class="popup_button outer">
		<ul>
			<li>
				<a href="javascript:setValue();" id="btnSave" class="gray large"><tit:txt mid='104476' mdef='저장'/></a>
				<a href="javascript:setComplate();" id="btnComplate" class="pink large"><tit:txt mid='appComLayout' mdef='신청'/></a>
				<a id="close" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
			</li>
		</ul>
		</div>
	</div>
</div>
</body>
</html>