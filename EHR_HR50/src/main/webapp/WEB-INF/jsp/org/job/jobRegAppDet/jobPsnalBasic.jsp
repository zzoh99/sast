<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>학자금신청 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

var searchApplSeq    = "${searchApplSeq}";
var adminYn          = "${adminYn}";
var authPg           = "${authPg}";
var searchApplSabun  = "${searchApplSabun}";
var searchApplInSabun= "${searchApplInSabun}";
var searchApplYmd    = "${searchApplYmd}";
var applStatusCd	 = "";
var applYn	         = "";
var pGubun           = "";
var gPRow = "";
var adminRecevYn     = "N"; //수신자 여부
var user;

	$(function() {
		
		parent.iframeOnLoad(300);

		
		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);
		
		$('#extMon').mask('000,000,000,000,000', { reverse : true });
		$('#applMon').mask('000,000,000,000,000', { reverse : true });
		$('#excRate').mask('000,000,000,000,000', { reverse : true });
		
		applStatusCd = parent.$("#applStatusCd").val();
		applYn = parent.$("#applYn").val(); // 현 결재자와 세션사번이 같은지 여부

		if(applStatusCd == "") {
			applStatusCd = "11";
		}
		
		if( ( adminYn == "Y" ) || ( applStatusCd == "31"  && applYn == "Y" ) ){ //담당자거나 수신결재자이면
			
			if( applStatusCd == "31") { //수신처리중일 때만 지급정보 수정 가능
				$("#payMon").removeClass("transparent").removeAttr("readonly");
				$("#payYm").removeClass("transparent").removeAttr("readonly");
				$("#payNote").removeClass("transparent").removeAttr("readonly");
				$("#payMon").mask('000,000,000,000,000', { reverse : true });
				$("#payYm").datepicker2({ymonly:true});
			}

			adminRecevYn = "Y";
			$(".payInfo").show();
			parent.iframeOnLoad(300);
		}
		
		//학자금구분 콤보
		var schTypeCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B60050"), " ");//학자금구분(B60050)
		$("#schTypeCd").html(schTypeCdList[2]);
		
		//신청분기 콤보
		var divCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B60060"), " ");//학자금분기(B60060)
		$("#divCd").html(divCdList[2]);
		
		// 신청, 임시저장
		if(authPg == "A") {
			
			$("#schEntYm").datepicker2({ymonly:true});
			$("#payYm").datepicker2({ymonly:true});
			$("#schPayYn").attr("disabled", false);
			$("#appYear").val("${curSysYear}");  //신청년도 고정

			// 신청금액 자동계산
			$("#extMon, #excRate").bind("keyup",function(event){
				if($("#extMon").val() !="" && $("#excRate").val() !="" ){
					var extMon = parseInt(replaceAll($("#extMon").val(), ",",""));
					var excRate = parseInt(replaceAll($("#excRate").val(), ",",""));
					$("#applMon").val(extMon * excRate).mask('000,000,000,000,000', { reverse : true });
				}
			});

			$("#schLocCd").bind("change", function(){
				if($("#schLocCd").val() == "1"){
					$("#extMon").addClass("${textCss}").addAttr("${readonly}");
					$("#excRate").addClass("${textCss}").addAttr("${readonly}");
				}else{
					$("#extMon").val("");
					$("#excRate").val("");
					$("#extMon").removeClass("transparent").removeAttr("readonly");
					$("#excRate").removeClass("transparent").removeAttr("readonly");
				}
				
			});
			
			
			// 학자금구분 선택 이벤트
			$("#schTypeCd").change(function() {
				
				var param = "&searchApplSabun="+searchApplSabun + "&schTypeCd="+$("#schTypeCd").val();
				var famList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getSchAppDetFamList"+param, false).codeList
				            , "famNm,famCd,famYmd,sexType,famCdNm"
				            , " ");

				$("#famResNo").html(famList[2]);

				//clear
				$("#famNm").val("");
				$("#famCd").val("");
				$("#famYmd").val("");
				$("#famCdNm").html("");
				$("#birYmd").html("");
				sheet1.RemoveAll();
			});
			
			// 대상자 선택 이벤트
			$("#famResNo").change(function() {
				var obj = $("#famResNo option:selected");
				$("#famNm").val(obj.attr("famNm"));
				$("#famCd").val(obj.attr("famCd"));
				$("#famYmd").val(obj.attr("famYmd"));
				$("#famCdNm").html(obj.attr("famCdNm"));
				
				//생년월일/성별 표시
				$("#birYmd").html(formatDate(obj.attr("famYmd"),"-")+" / "+obj.attr("sexType"));
				
				// 학자금이력조회
				doAction("SearchList");
			});
			
			// 국내/국외 선택 이벤트
			$("#schLocCd").change(function() {
				onApplMon(1);
			});
			
		} else if (authPg == "R") {
			$("#schPayYn").attr("disabled", true);
		}

		//----------------------------------------------------------------
		init_sheet();
		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
		
	});
	
	//Sheet 초기화
	function init_sheet(){
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"신청일",			Type:"Date",		Hidden:0, 	Width:60,	 Align:"Center", SaveName:"applYmd",		Format:"Ymd",	Edit:0 },
			{Header:"신청상태",		Type:"Combo",		Hidden:0, 	Width:60,	 Align:"Center", SaveName:"applStatusCd",	Format:"",		Edit:0 },

			{Header:"학자금구분",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"schTypeCd",	Edit:0 },
			{Header:"가족구분",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"famCd",		Edit:0 },
			{Header:"대상자명",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"famNm",		Edit:0 },
			{Header:"생년월일",		Type:"Date",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"famYmd",		Format:"Ymd", 	Edit:0 },
			{Header:"신청년도",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appYear",		Edit:0 },
			{Header:"신청분기",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"divCd",		Format:"###\\분기", 	Edit:0 },
			{Header:"신청금액",		Type:"Int",			Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"applMon",		Format:"#,###\\원",	Edit:0 },
			{Header:"지급금액",		Type:"AutoSum",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"payMon",		Format:"#,###\\원",	Edit:0 },
			{Header:"급여년월",		Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"payYm",		Format:"Ym", 	Edit:0 },

  			//Hidden
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"sabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq"}

  		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(0);sheet1.SetVisible(true);
  		sheet1.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게

		
 		//==============================================================================================================================
		//공통코드 한번에 조회
		var grpCds = "R10010,B60050,B60030";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y","grpCd="+grpCds,false).codeList, "");
		sheet1.SetColProperty("applStatusCd",  	{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} ); //신청상태 
		sheet1.SetColProperty("schTypeCd",  	{ComboText:"|"+codeLists["B60050"][0], ComboCode:"|"+codeLists["B60050"][1]} ); //학자금 
		sheet1.SetColProperty("famCd",  		{ComboText:"|"+codeLists["B60030"][0], ComboCode:"|"+codeLists["B60030"][1]} ); //대상자
		//==============================================================================================================================


	}
	
	//Sheet1 Action
	function doAction(sAction) {
		switch (sAction) {
			case "Search":
				// 입력 폼 값 셋팅
				var data = ajaxCall( "${ctx}/SchAppDet.do?cmd=getSchAppDetMap", $("#searchForm").serialize(),false);

				if ( data != null && data.DATA != null ){ 
					
					var vSexType = data.DATA.SexType;
					
					if(vSexType == "1"){
						vSexType = "남";
					}else{
						vSexType = "여";
					}
					
					$("#schTypeCd").val(data.DATA.schTypeCd);			// 학자금구분

					if(authPg == "A") {
						$("#schTypeCd").change();  //대상자콤보 생성
						$("#famResNo").val(data.DATA.famResNo);
					}else{
						$("#famResNo").html("<option value='"+data.DATA.famResNo+"'>"+data.DATA.famNm+"</option>");	
					}	
					
					$("#famNm").val(data.DATA.famNm);		// 가족명
					$("#famCd").val(data.DATA.famCd);		// 가족구분코드
					$("#famCdNm").html(data.DATA.famCdNm);
					$("#famYmd").val(data.DATA.famYmd);		// 생년월일
					$("#birYmd").html(formatDate(data.DATA.famYmd,"-") + " / " + vSexType);	// 생년월일/성별
					$("#appYear").val(data.DATA.appYear);	// 신청년도
					$("#divCd").val(data.DATA.divCd);			// 신청분기
					$("#schName").val(data.DATA.schName);		// 학교명
					$("#schLocCd").val(data.DATA.schLocCd);		// 국내/국외
					$("#schDept").val(data.DATA.schDept);		// 학과명
					$("#schYear").val(data.DATA.schYear);		// 학년
					$("#schEntYm").val(formatDate(data.DATA.schEntYm,"-"));	// 입학년월
					
					if(data.DATA.schPayYn == "Y"){
						$(':checkbox[name=schPayYn]').attr('checked', true);
					}else{
						$(':checkbox[name=schPayYn]').attr('checked', false);
					}
					
					$("#extMon").val(makeComma(data.DATA.extMon));	// 외화금액
					$("#excRate").val(data.DATA.excRate);	// 환율
					$("#applMon").val(makeComma(data.DATA.applMon));	// 신청금액
					$("#applMon_won").html( ( $("#applMon").val() == "")?"":" 원");	// 신청금액 원
					$("#note").val(data.DATA.note);	// 특이사항
					
					if( adminRecevYn == "Y" ){
						$("#payMon").val(makeComma(data.DATA.payMon));
						$("#payYm").val(formatDate(data.DATA.payYm, "-"));
						$("#payNote").val(data.DATA.payNote);
					}

					// 학자금이력조회
					doAction("SearchList");
					
				}

				break;
			case "SearchList":
			      
			    var params = "searchApplSabun="+$("#searchApplSabun").val()
	               		   + "&searchApplSeq="+$("#searchApplSeq").val()
			               + "&schTypeCd="+$("#schTypeCd").val()
			               + "&famResNo="+encodeURIComponent($("#famResNo").val());
			       
				var sXml = sheet1.GetSearchData("${ctx}/SchAppDet.do?cmd=getSchAppDetList", params);
				sXml = replaceAll(sXml,"rowBackColor", "BackColor");
				sheet1.LoadSearchData(sXml );
	        	break;	
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	// 셀 선택 시 
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if( NewRow > 0 ){
				sheet1.SetSelectRow(-1);
			}
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}

	
	//--------------------------------------------------------------------------------
	//  저장 시 필수 입력 및 조건 체크
	//--------------------------------------------------------------------------------
	function checkList(status) {
		var ch = true;

		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은(는) 필수값입니다.' />");
				$(this).focus();
				ch =  false;
				return false;
			}

			return ch;
		});
		
		if( ch ){
			var params = "searchGubun=P&"+$("#searchForm").serialize();
			//학자금 체크 
			var map = ajaxCall( "${ctx}/SchAppDet.do?cmd=getSchAppDupChk",params,false);
			if ( map != null && map.DATA != null ){
				if( map.DATA.msg != "OK" ){
					alert(replaceAll(map.DATA.msg,"/n","\n"));
					ch =  false;
					return false;
				}

			}

		}

		return ch;
	}

	
	//--------------------------------------------------------------------------------
	//  저장 시 필수 입력 및 조건 체크
	//--------------------------------------------------------------------------------
	function checkListAdmin(status) {
		var ch = true;

		if( $("#payMon").val() == "" ) return true;
		//년간한도 체크 
		var params = "searchGubun=A&searchApplSeq="+$("#searchApplSeq").val()
		           + "&searchApplSabun="+$("#searchApplSabun").val()
		           + "&schTypeCd="+$("#schTypeCd").val()
		           + "&famCd="+$("#famCd").val()
		           + "&famYmd="+$("#famYmd").val()
		           + "&famResNo="+encodeURIComponent($("#famResNo").val())
		           + "&appYear="+$("#appYear").val()
		           + "&divCd="+$("#divCd").val()
		           + "&applMon="+$("#payMon").val();
		var map = ajaxCall( "${ctx}/SchAppDet.do?cmd=getSchAppDupChk",params,false);
		if ( map != null && map.DATA != null ){
			if( map.DATA.msg != "OK" ){
				alert(replaceAll(map.DATA.msg,"/n","\n"));
				ch =  false;
				return false;
			}

		}

		return ch;
	}
	//--------------------------------------------------------------------------------
	//  임시저장 및 신청 시 호출
	//--------------------------------------------------------------------------------
	function setValue(status) {
		//전송 전 잠근 계좌선택 풀기
		var returnValue = false;
		try {
			
			//관리자 수신담당자 경우 지급정보 저장
			if( adminRecevYn == "Y" ){

				if( applStatusCd != "31") { //수신처리중이 아니면 저장 처리 하지 않음
					return true;
				}
				//지급한도 체크 
		        if ( !checkListAdmin() ) {
		            return false;
		        }
				
				var rtn = ajaxCall("${ctx}/SchAppDet.do?cmd=saveSchAppDetAdmin", $("#searchForm").serialize(), false);

				if(rtn.Result.Code < 1) {
					alert(rtn.Result.Message);
					returnValue = false;
				} else {
					returnValue = true;
				}
				
			}else{
			
				if ( authPg == "R" )  {
					return true;
				}
				
				// 항목 체크 리스트
		        if ( !checkList() ) {
		            return false;
		        }
		        
		        if( !$("#schPayYn").is(":checked") ){
		        	$("#schPayYnVal").val("N");
		        }else{
		        	$("#schPayYnVal").val("Y");
		        }
		        
		      	//저장
				var data = ajaxCall("${ctx}/SchAppDet.do?cmd=saveSchAppDet", $("#searchForm").serialize(), false);
	
	            if(data.Result.Code < 1) {
	                alert(data.Result.Message);
					returnValue = false;
	            }else{
					returnValue = true;
	            }
				
			}    

		} catch (ex){
			alert("Error!" + ex);
			returnValue = false;
		}

		return returnValue;
	}
	
	
</script>

<style type="text/css">

/*---- checkbox ----*/
input[type="checkbox"]  { 
	display:inline-block; width:20px; height:20px; cursor:pointer; appearance:none; 
 	-moz-appearance:checkbox; -webkit-appearance:checkbox; margin-top:2px;background:none;
    border: 5px solid red;
}
label {
	vertical-align:-2px;padding-right:10px;
}

.payInfo { display:none; }
.payInfo th {background-color:#f4f4f4 !important; }
</style>
</head>
<body class="bodywrap">
<div class="wrapper">

	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	<input type="hidden" id="searchAuthPg"		name="searchAuthPg"	     value=""/>
	<input type="hidden" id="searchSabun"		name="searchSabun"	     value=""/>
	
	<input type="hidden" id="famNm"				name="famNm"	     value=""/>
	<input type="hidden" id="famCd"				name="famCd"	     value=""/>
	<input type="hidden" id="famYmd"			name="famYmd"	     value=""/>
	<input type="hidden" id="closeYn"			name="closeYn"	 	 value="N"/>
	<input type="hidden" id="schPayYnVal"		name="schPayYnVal"	 value=""/>
	
	<div class="sheet_title">
		<ul>
			<li class="txt">신청내용</li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="120px" />
			<col width="35%" />
			<col width="120px" />
			<col width="" />
		</colgroup>
	
		<tr>
			<th>학자금구분</th>
			<td>
				<select id="schTypeCd" name="schTypeCd" class="${selectCss} ${required} " ${disabled}></select>
			</td>
			<th>가족구분</th>
			<td>
				<div id="famCdNm"></div>
			</td>
		</tr>	
		<tr>
			<th>대상자</th>
			<td>
				<select id="famResNo" name="famResNo" class="${selectCss} ${required} " ${disabled}></select>
			</td>
			<th>생년월일/성별</th>
			<td>
				<div id="birYmd"></div>
			</td>
		</tr>	
		<tr>
			<th>신청년도</th>
			<td>
				<input type="text" id="appYear" name="appYear" class="${textCss}  w30" readonly maxlength="20"/>
			</td> 
			<th>신청분기</th>
			<td>
				<select id="divCd" name="divCd" class="${selectCss} ${required} " ${disabled}></select>
			</td> 
		</tr>
		<tr>
			<th>학교명</th>
			<td>
				<input type="text" id="schName" name="schName" class="${textCss} ${required} w100p" ${readonly} maxlength="20"/>
			</td> 
			<th>국내/국외</th>
			<td>
				<select id="schLocCd" name="schLocCd" class="${selectCss} " ${disabled}>
					<option value="0" selected>국내</option>
					<option value="1">국외</option>
				</select>
			</td> 
		</tr>
		<tr>
			<th>학과명</th>
			<td>
				<input type="text" id="schDept" name="schDept" class="${textCss} w100p" ${readonly} maxlength="20"/>
			</td> 
			<th>학년</th>
			<td>
				<select id="schYear" name="schYear" class="${selectCss} " ${disabled}>
					<option value=""> </option>
					<option value="1">1학년</option>
					<option value="2">2학년</option>
					<option value="3">3학년</option>
					<option value="4">4학년</option>
					<option value="5">5학년</option>
					<option value="6">6학년</option>
					<option value="7">7학년</option>
					<option value="8">8학년</option>
					<option value="9">9학년</option>
					<option value="10">10학년</option>
				</select>
			</td> 
		</tr>
		<tr>
			<th>입학년월</th>
			<td>
				<input type="text" id="schEntYm" name="schEntYm" class="${dateCss} w80" ${readonly} maxlength="10"/>
			</td> 
			<th>장학금수혜여부</th>
			<td>
				<input type="checkbox" id="schPayYn" name="schPayYn" style="vertical-align:middle;" ${disabled}/>
			</td> 
		</tr>
		<tr>
			<th>외화금액</th>
			<td>
				<input type="text" id="extMon" name="extMon" class="${textCss} w100 ${readonly}" ${readonly}/>
			</td> 
			<th>환율</th>
			<td>
				<input type="text" id="excRate" name="excRate" class="${textCss} w80 ${readonly}" ${readonly} maxlength="20"/>
			</td> 
		</tr>
		<tr>
			<th>신청금액</th>
			<td colspan="3">
				<input id="applMon" name="applMon" type="text" class="${textCss} ${required} w100 with-unit" ${readonly}/><span id="applMon_won"></span>
			</td> 
		</tr>
		<tr>
			<th>특이사항</th>
			<td colspan="3">
				<input type="text" id="note" name="note" class="${textCss} w100p " ${readonly}/>
			</td> 
		</tr>
		</table>
		
		<div class="sheet_title">
			<ul>
				<li class="txt">학자금 신청 이력</li>
			</ul>
		</div>
		
		<script type="text/javascript">createIBSheet("sheet1", "100%", "150px"); </script>
		
		<div class="sheet_title payInfo">
			<ul>
				<li class="txt">지급정보</li>
			</ul>
		</div>
		<table class="table payInfo">
			<colgroup>
				<col width="120px" />
				<col width="25%" />
				<col width="120px" />
				<col width="" />
			</colgroup>
			<tr>
				<th>지급금액</th>
				<td><input type="text" id="payMon" name="payMon" class="text transparent w100"/></td>
				<th>지급년월</th>
				<td><input type="text" id="payYm" name="payYm" class="date2 transparent w80" maxlength="10"/></td>
			</tr>
			<tr>
				<th>지급메모</th>
				<td colspan="3"><input type="text" id="payNote" name="payNote" class="text transparent w90p"/></td>
			</tr>
		</table>
		
	</form>
</div>
		
</body>
</html>