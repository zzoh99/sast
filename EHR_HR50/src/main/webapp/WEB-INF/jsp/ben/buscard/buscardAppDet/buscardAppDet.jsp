<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>명함신청 세부내역</title>
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
var pGubun           = "";
var gPRow = "";

	$(function() {
		
		parent.iframeOnLoad(220);

		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);
		applStatusCd = parent.$("#applStatusCd").val();

		if(applStatusCd == "") {
			applStatusCd = "11";
		}

		//----------------------------------------------------------------

		//명함타입 콤보 		
		var cardTypeCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B76110"), " ");//명함타입코드(B76110)
		$("#cardTypeCd").html(cardTypeCdList[2]);
				
		// 신청, 임시저장
		if(authPg == "A") {
			
			$("#nameEn").maxbyte(100);
			$("#orgNm").maxbyte(100);
			$("#orgNmEn").maxbyte(200);
			$("#jikweeNm").maxbyte(20);
			$("#jikweeNmEn").maxbyte(100);
			$("#phoneNo").maxbyte(20);
			$("#phoneNoEn").maxbyte(20);
			$("#mailId").maxbyte(50);
			$("#telNo").maxbyte(20);
			$("#telNoEn").maxbyte(20);
			$("#faxNo").maxbyte(20);
			$("#faxNoEn").maxbyte(20);
			$("#compAddr").maxbyte(300);
			$("#compAddrEn").maxbyte(300);
			$("#note").maxbyte(1000);
			
		} else if (authPg == "R") {		
		}

		doAction("Search");		
	});
	
	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/BuscardApp.do?cmd=getBuscardAppDetMap", $("#searchForm").serialize(),false);

			if ( data != null && data.DATA != null ){ 
	
			 	$("#name").val(data.DATA.name);
				$("#nameEn").val(data.DATA.nameEn);						
				$("#orgNm").val(data.DATA.orgNm);
				$("#orgNmEn").val(data.DATA.orgNmEn);
				$("#jikweeNm").val(data.DATA.jikweeNm);
				$("#jikweeNmEn").val(data.DATA.jikweeNmEn);
				$("#phoneNo").val(data.DATA.phoneNo);
				$("#phoneNoEn").val(data.DATA.phoneNoEn);
				$("#telNo").val(data.DATA.telNo);
				$("#telNoEn").val(data.DATA.telNoEn);				
				$("#mailId").val(data.DATA.mailId);
				$("#faxNo").val(data.DATA.faxNo);
				$("#faxNoEn").val(data.DATA.faxNoEn);
				$("#compAddr").val(data.DATA.compAddr);
				$("#compAddrEn").val(data.DATA.compAddrEn);
				$("#cardTypeCd").val(data.DATA.cardTypeCd);				
				$("#note").val(data.DATA.note);

			}

			break;
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

		return ch;
	}
	
	//--------------------------------------------------------------------------------
	//  임시저장 및 신청 시 호출
	//--------------------------------------------------------------------------------
	function setValue(status) {

		var returnValue = false;
		try {

			if ( authPg == "R" )  {
				return true;
			}
			
	        // 항목 체크 리스트
	        if ( !checkList() ) {
	            return false;
	        }
	        

	      	//저장
			var data = ajaxCall("${ctx}/BuscardApp.do?cmd=saveBuscardAppDet",$("#searchForm").serialize(),false);

            if(data.Result.Code < 1) {
                alert(data.Result.Message);
				returnValue = false;
            }else{
				returnValue = true;
            }
			
			

		} catch (ex){
			alert("Error!" + ex);

			returnValue = false;
		}

		return returnValue;
	}	
	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
 
	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	<input type="hidden" id="searchAuthPg"		name="searchAuthPg"	     value=""/>

	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='appTitle' mdef='신청내용'/></li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="120px" />
			<col width="30%" />
			<col width="120px" />
			<col width="" />
		</colgroup>
	
		<tr>
			<th><tit:txt mid='104450' mdef='성명 '/></th>
			<td>
				<input type="text" id="name" name="name" class="text transparent w80 " readonly/>				
			</td>
			<th><tit:txt mid='104533' mdef='영문성명'/></th>
			<td>
				<input type="text" id="nameEn" name="nameEn" class="${dateCss} ${required} w150" ${readonly}  />
			</td>
		</tr>	
		<tr>
			<th><tit:txt mid='113316' mdef='부서명'/></th>
			<td>
				<input type="text" id="orgNm" name="orgNm" class="${dateCss} ${required} w100p" ${readonly} />
			</td>
			<th><tit:txt mid='orgNmEng' mdef='영문부서명'/></th>
			<td>
				<input type="text" id="orgNmEn" name="orgNmEn" class="${textCss} ${required} w100p" ${readonly} />
			</td>
		</tr>	
		<tr>
			<th><tit:txt mid='104104' mdef='직위' /></th>
			<td>
				<input type="text" id="jikweeNm" name="jikweeNm" class="${textCss} ${required} w100" ${readonly}/>
			</td> 
			<th><tit:txt mid='jikweeNmEn' mdef='영문직위명'/></th>
			<td>
				<input type="text" id="jikweeNmEn" name="jikweeNmEn" class="${textCss} ${required} w150" ${readonly}/>
			</td> 
		</tr>
		<tr>
			<th><tit:txt mid='112168' mdef='핸드폰 번호'/></th>
			<td>
				<input type="text" id="phoneNo" name="phoneNo" class="${textCss} ${required} w150" ${readonly}/>
			</td> 
			<th><tit:txt mid='phoneNoEn' mdef='영문 핸드폰번호'/></th>
			<td>
				<input type="text" id="phoneNoEn" name="phoneNoEn" class="${textCss} ${required} w150" ${readonly}/>
		</tr>
		<tr>
			<th><tit:txt mid='mailId' mdef='메일주소'/></th>
			<td colspan="3">
				<input type="text" id="mailId" name="mailId" class="${textCss} ${required} w300" ${readonly}/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='112985' mdef='전화번호'/></th>
			<td>
				<input type="text" id="telNo" name="telNo" class="${textCss} ${required} w150" ${readonly}/>
			</td> 
			<th><tit:txt mid='telNoEn' mdef='영문전화번호'/></th>
			<td>
				<input type="text" id="telNoEn" name="telNoEn" class="${textCss} ${required} w150" ${readonly}/>
			</td> 
		</tr>	
		<tr>
			<th><tit:txt mid='104428' mdef='팩스번호'/></th>
			<td>
				<input type="text" id="faxNo" name="faxNo" class="${textCss} ${required} w150" ${readonly}/>
			</td> 
			<th><tit:txt mid='faxNoEn' mdef='영문팩스번호'/></th>
			<td>
				<input type="text" id="faxNoEn" name="faxNoEn" class="${textCss} ${required} w150" ${readonly}/>
			</td> 
		</tr>		
		<tr>
			<th><tit:txt mid='compAddr' mdef='회사주소'/></th>
			<td colspan="3">
				<input type="text" id="compAddr" name="compAddr" class="${textCss} ${required} w100p" ${readonly}/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='compAddrEn' mdef='영문회사주소'/></th>
			<td colspan="3">
				<input type="text" id="compAddrEn" name="compAddrEn" class="${textCss} ${required} w100p" ${readonly}/>
			</td>
		</tr>		
		<tr>
			<th><tit:txt mid='buscardType' mdef='명함타입'/></th>
			<td>
				<select id="cardTypeCd" name="cardTypeCd" class="${selectCss} ${required} " ${disabled}></select>
			</td>			
		</tr>	
		<tr>
			<th><tit:txt mid='103783' mdef='비고' /></th>
			<td colspan="3"><textarea id="note" name="note" rows="3" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea></td>
		</tr>
		</table>
		
	</form>
</div>
		
</body>
</html>