<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>교육기관관리 팝업</title>
<script type="text/javascript">
	$(function(){

		var nationalCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20290"), "");	//소재국가
		var bankCd		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H30001"), "");	//은행명
	
		$("#nationalCd").html(nationalCd[2]);
		$("#bankCd").html(bankCd[2]);
		$("#nationalCd").val("KR");

		const modal = window.top.document.LayerModalUtility.getModal('eduInstiMgrDetLayer');
		var arg = modal.parameters;
		var eduOrgCd         = arg["eduOrgCd"]        ;
		var eduOrgNm         = arg["eduOrgNm"]        ;
		var nationalCd       = arg["nationalCd"]      ;
		var zip              = arg["zip"]             ;
		var curAddr1         = arg["curAddr1"]        ;
		var curAddr2         = arg["curAddr2"]        ;
		var bigo             = arg["bigo"]            ;
		var chargeName       = arg["chargeName"]      ;
		var orgNm            = arg["orgNm"]           ;
		var jikweeNm         = arg["jikweeNm"]        ;
		var telNo            = arg["telNo"]           ;
		var telHp            = arg["telHp"]           ;
		var faxNo            = arg["faxNo"]           ;
		var email            = arg["email"]           ;
		var companyNum       = arg["companyNum"]      ;
		var companyHead      = arg["companyHead"]     ;
		var businessPart     = arg["businessPart"]    ;
		var businessType     = arg["businessType"]    ;
		var bankNum          = arg["bankNum"]         ;
		var bankCd           = arg["bankCd"]          ;
		var fileSeq 		 = arg["fileSeq"];
	
		if ( "${authPg}" == "R"){
			$(".asred").hide();
			$("#eduInstiMgrDetLayerFrm #eduInstiMgrDetLayerFrm #eduOrgCd").val(eduOrgCd        		).addClass("readonly").attr("disabled", true) ;
			$("#eduInstiMgrDetLayerFrm #eduOrgNm").val(eduOrgNm        		).addClass("readonly").attr("disabled", true).removeClass("required") ;
			$("#eduInstiMgrDetLayerFrm #nationalCd").val(nationalCd      	).addClass("readonly").attr("disabled", true) ;
			$("#eduInstiMgrDetLayerFrm #zip").val(zip             			).addClass("readonly").attr("disabled", true) ;
			$("#eduInstiMgrDetLayerFrm #curAddr1").html(curAddr1        	).addClass("readonly").attr("disabled", true) ;
			$("#eduInstiMgrDetLayerFrm #curAddr2").val(curAddr2        		).addClass("readonly").attr("disabled", true) ;
			$("#eduInstiMgrDetLayerFrm #bigo").val(bigo            			).addClass("readonly").attr("disabled", true) ;
			$("#eduInstiMgrDetLayerFrm #chargeName").val(chargeName      	).addClass("readonly").attr("disabled", true) ;
			$("#eduInstiMgrDetLayerFrm #orgNm").val(orgNm           		).addClass("readonly").attr("disabled", true) ;
			$("#eduInstiMgrDetLayerFrm #jikweeNm").val(jikweeNm        		).addClass("readonly").attr("disabled", true) ;
			$("#eduInstiMgrDetLayerFrm #telNo").val(telNo           		).addClass("readonly").attr("disabled", true) ;
			$("#eduInstiMgrDetLayerFrm #telHp").val(telHp          		 	).addClass("readonly").attr("disabled", true) ;
			$("#eduInstiMgrDetLayerFrm #faxNo").val(faxNo           		).addClass("readonly").attr("disabled", true) ;
			$("#eduInstiMgrDetLayerFrm #email").val(email           		).addClass("readonly").attr("disabled", true) ;
			$("#eduInstiMgrDetLayerFrm #companyNum").val(companyNum      	).addClass("readonly").attr("disabled", true).removeClass("required") ;
			$("#eduInstiMgrDetLayerFrm #companyHead").val(companyHead     	).addClass("readonly").attr("disabled", true) ;
			$("#eduInstiMgrDetLayerFrm #businessPart").val(businessPart    	).addClass("readonly").attr("disabled", true) ;
			$("#eduInstiMgrDetLayerFrm #businessType").val(businessType    	).addClass("readonly").attr("disabled", true) ;
			$("#eduInstiMgrDetLayerFrm #bankNum").val(bankNum         		).addClass("readonly").attr("disabled", true) ;
			$("#eduInstiMgrDetLayerFrm #bankCd").val(bankCd          		).addClass("readonly").attr("disabled", true) ;
		}else{
	
			$("#eduInstiMgrDetLayerFrm #eduOrgCd").val(eduOrgCd        		) ;
			$("#eduInstiMgrDetLayerFrm #eduOrgNm").val(eduOrgNm        		) ;
			$("#eduInstiMgrDetLayerFrm #nationalCd").val(nationalCd      	) ;
			$("#eduInstiMgrDetLayerFrm #zip").val(zip             			) ;
			$("#eduInstiMgrDetLayerFrm #curAddr1").html(curAddr1        	) ;
			$("#eduInstiMgrDetLayerFrm #curAddr2").val(curAddr2        		) ;
			$("#eduInstiMgrDetLayerFrm #bigo").val(bigo            			) ;
			$("#eduInstiMgrDetLayerFrm #chargeName").val(chargeName      	) ;
			$("#eduInstiMgrDetLayerFrm #orgNm").val(orgNm           		) ;
			$("#eduInstiMgrDetLayerFrm #jikweeNm").val(jikweeNm        		) ;
			$("#eduInstiMgrDetLayerFrm #telNo").val(telNo           		) ;
			$("#eduInstiMgrDetLayerFrm #telHp").val(telHp          		 	) ;
			$("#eduInstiMgrDetLayerFrm #faxNo").val(faxNo           		) ;
			$("#eduInstiMgrDetLayerFrm #email").val(email           		) ;
			$("#eduInstiMgrDetLayerFrm #companyNum").val(companyNum      	) ;
			$("#eduInstiMgrDetLayerFrm #companyHead").val(companyHead     	) ;
			$("#eduInstiMgrDetLayerFrm #businessPart").val(businessPart    	) ;
			$("#eduInstiMgrDetLayerFrm #businessType").val(businessType    	) ;
			$("#eduInstiMgrDetLayerFrm #bankNum").val(bankNum         		) ;
			$("#eduInstiMgrDetLayerFrm #bankCd").val(bankCd          		) ;
			$("#eduInstiMgrDetLayerFrm #fileSeq").val(fileSeq) ;
		}
		
		if($("#eduInstiMgrDetLayerFrm #nationalCd").val()!="") $("#eduInstiMgrDetLayerFrm #nationalCd").val("KR").prop("selected",true);
		
	});


	function setValue() {

		if ($("#eduInstiMgrDetLayerFrm #eduOrgNm").val() == "") {
			alert("교육기관명은 필수값입니다.");
		}

		var param = "&curAddr1=" + $("#eduInstiMgrDetLayerFrm #curAddr1").text();

		var rtn = ajaxCall("${ctx}/Popup.do?cmd=saveEduInstiMgrDet", $("#eduInstiMgrDetLayerFrm").serialize()
				+ param, false);

		if (rtn.Result.Code < 1) {
			alert(rtn.Result.Message);
			return;
		} else {
			alert(rtn.Result.Message);
		}
		
		const modal = window.top.document.LayerModalUtility.getModal('eduOrgLayer');
		modal.fire('eduOrgLayerTrigger', {}).hide();
	}

	var gPRow = "";
	var pGubun = "";

	// 팝업 클릭시 발생
	function zipCodePopup() {
		if (!isPopup()) {
			return;
		}

		gPRow = "";
		pGubun = "viewZipCodePopup";

		var url = '/ZipCodePopup.do?cmd=viewZipCodeLayer&authPg=${authPg}';
		var layer = new window.top.document.LayerModal({
			id : 'zipCodeLayer'
			, url : url
			, width : 740
			, height : 620
			, title : '우편번호 검색'
			, trigger :[
				{
					name : 'zipCodeLayerTrigger'
					, callback : function(result){
						$("#eduInstiMgrDetLayerFrm #zip").val(result.zip);
						$("#eduInstiMgrDetLayerFrm #curAddr1").val(result.doroFullAddr);
					}
				}
			]
		});
		layer.show();
	}
</script>
</head>
<body class="bodywrap">
<form id="eduInstiMgrDetLayerFrm" name="eduInstiMgrDetLayerFrm" method="post">
<input type=hidden id="fileSeq"   	name="fileSeq">

<div class="wrapper modal_layer">
	<div class="modal_body">
		<table class="table">
			<colgroup>
				<col width="20%" />
				<col width="30%" />
				<col width="20%" />
				<col width="30%" />
			</colgroup>
			<tr>
				<th>교육기관명<font color="red" class="asred"> *</font></th>
				<td>
					<input id="eduOrgCd" name="eduOrgCd" type="hidden" class="text" style="width:50%;"/>
					<input id="eduOrgNm" name="eduOrgNm" type="text" class="text required" style="width:99%;ime-mode:active;" />
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='112055' mdef='우편번호'/></th>
				<td colspan="3">
					<input id="zip" name="zip" type="text" class="text w50"/>
					<a href="javascript:zipCodePopup();" class="button6 asred"><img src="/common/${theme}/images/btn_search2.gif"/></a>
					<span id="curAddr1"> </span>
				</td>
			</tr>
			<tr class="hide">
				<th><tit:txt mid='113463' mdef='상세주소'/></th>
				<td colspan="3">
					<input id="curAddr2" name="curAddr2" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='bigoV1' mdef='교육기관특성'/></th>
				<td colspan="3">
					<textarea id="bigo" name="bigo" rows="3" class="text w100p" style="ime-mode:active;"></textarea>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='nationalCdV1' mdef='국가코드'/></th>
				<td>
					<select id="nationalCd" name="nationalCd">
					</select>
				</td>
				<th><tit:txt mid='manager' mdef='담당자'/></th>
				<td>
					<input id="chargeName" name="chargeName" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104471' mdef='직급'/></th>
				<td>
					<input id="jikweeNm" name="jikweeNm" type="text" class="text" style="width:99%;"/>
				</td>
				<th><tit:txt mid='104550' mdef='핸드폰'/></th>
				<td>
					<input id="telHp" name="telHp" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='201705240000058' mdef='전화'/></th>
				<td>
					<input id="telNo" name="telNo" type="text" class="text" style="width:99%;"/>
				</td>
				<th><tit:txt mid='112914' mdef='팩스'/></th>
				<td>
					<input id="faxNo" name="faxNo" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th>E-mail</th>
				<td colspan="3">
					<input id="email" name="email" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th>사업자등록번호<!-- font color="red" class="asred"> *</font --></th>
				<td>
					<input id="companyNum" name="companyNum" type="text" class="text" style="width:99%;"/>
				</td>
				<th><tit:txt mid='companyHead' mdef='대표자명'/></th>
				<td>
					<input id="companyHead" name="companyHead" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='113119' mdef='업태'/></th>
				<td>
					<input id="businessPart" name="businessPart" type="text" class="text" style="width:99%;"/>
				</td>
				<th><tit:txt mid='112066' mdef='종목'/></th>
				<td>
					<input id="businessType" name="businessType" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104465' mdef='계좌번호'/></th>
				<td>
					<input id="bankNum" name="bankNum" type="text" class="text" style="width:99%;"/>
				</td>
				<th><tit:txt mid='104277' mdef='은행명'/></th>
				<td>
					<select id="bankCd" name="bankCd">
					</select>
				</td>
			</tr>
		</table>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:setValue();" css="btn filled authA" mid='110708' mdef="저장"/>
		<btn:a href="javascript:closeCommonLayer('eduInstiMgrDetLayer');" css="btn outline_gray authR" mid='110881' mdef="닫기"/>
	</div>
</div>
</form>
</body>
</html>
