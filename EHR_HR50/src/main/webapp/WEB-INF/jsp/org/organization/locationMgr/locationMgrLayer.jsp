<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112883' mdef='Location관리 팝업'/></title>
<!-- <script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script> -->
<style type="text/css">
</style>
<script type="text/javascript">
$(function(){
	var nationalCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20290"), " ");	//소재국가
	//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
	var url     = "queryId=getBusinessPlaceCdList";
	var allFlag = true;
	if ("${ssnSearchType}" != "A"){
		url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
		allFlag = false;
	}
	var businessPlaceCd = "";
	if(allFlag) {
		businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "<tit:txt mid='103895' mdef='전체'/>" : "All"));	//사업장
	} else {
		businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
	}
	var locationCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, "");	//LOCATION

	$("#nationalCd").html(nationalCd[2]);
	$("#taxBpCd").html(businessPlaceCd[2]);
	$("#taxLocationCd").html(locationCd[2]);

	var modal = window.top.document.LayerModalUtility.getModal('locationMgrLayer');
	var { locationCd, locationNm, nationalCd, zip, 
		  addr, detailAddr, engAddr, detailEngAddr, 
		  taxBpCd, taxLocationCd, taxOfficeNm, 
		  recOfficeNm, officeTaxYn, orderSeq } = modal.parameters;
	$("#locationCd").val(locationCd);
	$("#locationNm").val(locationNm);
	$("#nationalCd").val(nationalCd);
	$("#zip").val(zip);
	$("#addr").val(addr);
	$("#detailAddr").val(detailAddr);
	$("#engAddr").val(engAddr);
	$("#detailEngAddr").val(detailEngAddr);
	$("#taxBpCd").val(taxBpCd);
	$("#taxLocationCd").val(taxLocationCd);
	$("#taxOfficeNm").val(taxOfficeNm);
	$("#recOfficeNm").val(recOfficeNm);
	$("#officeTaxYn").val(officeTaxYn);
	$("#orderSeq").val(orderSeq);

	// 숫자만 입력
	$("#orderSeq").keyup(function() {
	     makeNumber(this,'A')
	 });
});

function setValue() {
	var rv = new Array(6);
	rv["locationCd"] 	= $("#locationCd").val();
	rv["locationNm"]	= $("#locationNm").val();
	rv["nationalCd"] 	= $("#nationalCd").val();
	rv["zip"] 			= $("#zip").val();
	rv["addr"]			= $("#addr").val();
	rv["detailAddr"]	= $("#detailAddr").val();
	rv["engAddr"]		= $("#engAddr").val();
	rv["detailEngAddr"]	= $("#detailEngAddr").val();
	rv["taxBpCd"]		= $("#taxBpCd").val();
	rv["taxLocationCd"]	= $("#taxLocationCd").val();
	rv["taxOfficeNm"]	= $("#taxOfficeNm").val();
	rv["recOfficeNm"]	= $("#recOfficeNm").val();
	rv["officeTaxYn"]	= $("#officeTaxYn").val();
	rv["orderSeq"]		= $("#orderSeq").val();
	var modal = window.top.document.LayerModalUtility.getModal('locationMgrLayer');
	modal.fire('locationMgrLayerTrigger', rv).hide();
}

// 팝업 클릭시 발생
function zipCodePopup() {
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
                        $("#zip").val(result.zip);
                    	$("#addr").val(result["doroAddr"]);
                    	$("#detailAddr").val(result["detailAddr"]);
                    	$("#engAddr").val(result["resDoroFullAddrEng"]);
                    	$("#detailEngAddr").val(result["detailAddr"]);
                    }
                }
            ]
        });
	layer.show();
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<table class="table">
			<colgroup>
				<col width="15%" />
				<col width="15%" />
				<col width="70%" />
			</colgroup>
			<input type="hidden" id="locationCd" name="locationCd">
			<tr>
				<th colspan="2">LOCATION명칭 </th>
				<td>
					<input id="locationNm" name="locationNm" type="text" class="text" style="width:50%;"/>
				</td>
			</tr>
			<tr>
				<th colspan="2"><tit:txt mid='112199' mdef='소재국가'/></th>
				<td>
					<select id="nationalCd" name="nationalCd">
						<option value=""></option>
					</select>
				</td>
			</tr>
			<tr>
				<th colspan="2"><tit:txt mid='112055' mdef='우편번호'/></th>
				<td>
					<input id="zip" name="zip" type="text" class="text"/>
					<a href="javascript:zipCodePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				</td>
			</tr>
			<tr>
				<th colspan="2"><tit:txt mid='address' mdef='주소'/></th>
				<td>
					<input id="addr" name="addr" type="text" class="text" style="width:99%;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<th colspan="2"><tit:txt mid='113463' mdef='상세주소'/></th>
				<td>
					<input id="detailAddr" name="detailAddr" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th colspan="2"><tit:txt mid='111915' mdef='영문주소'/></th>
				<td>
					<input id="engAddr" name="engAddr" type="text" class="text" style="width:99%;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<th colspan="2"><tit:txt mid='112745' mdef='영문상세주소'/></th>
				<td>
					<input id="detailEngAddr" name="detailEngAddr" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>
			<tr>
				<th colspan="2"><tit:txt mid='114399' mdef='사업장'/></th>
				<td>
					<select id="taxBpCd" name="taxBpCd">
						<option value=""></option>
					</select>
				</td>
			</tr>
			<tr>
				<th rowspan="3" align="center"><!-- <span style="display:block;text-align:center;"> -->지방소득세<!-- </span> --></th>
				<th>LOCATION</th>
				<td>
					<select id="taxLocationCd" name="taxLocationCd">
						<option value=""></option>
					</select>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='112200' mdef='관할구청'/></th>
				<td>
					<input id="taxOfficeNm" name="taxOfficeNm" type="text" class="text" style="width:50%;"/>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='114301' mdef='취급청'/></th>
				<td>
					<input id="recOfficeNm" name="recOfficeNm" type="text" class="text" style="width:50%;"/>
				</td>
			</tr>
			<tr>
				<th colspan="2"><tit:txt mid='112884' mdef='사업소세 대상여부'/></th>
				<td>
					<select id="officeTaxYn" name="officeTaxYn">
						<option value='Y'>YES</option>
						<option value='N'>NO</option>
					</select>
				</td>
			</tr>
			<tr>
				<th colspan="2"><tit:txt mid='111896' mdef='순서'/></th>
				<td>
					<input id="orderSeq" name="orderSeq" type="text" class="text" maxlength="3" vtxt="MaxLength Text"/>
				</td>
			</tr>
		</table>
	</div>
	<div class="modal_footer">
		<a href="javascript:closeCommonLayer('locationMgrLayer');" class="btn outline_gray authR"><tit:txt mid='104157' mdef='닫기'/></a>
		<a href="javascript:setValue();" class="btn filled authA"><tit:txt mid='104435' mdef='확인'/></a>
	</div>
</div>

</body>
</html>
