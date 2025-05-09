<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>주소 가져오기</title>
<script type="text/javascript">
	var authPg	= "";

	$(function(){
		
		$(".close").click(function() 	{ closeCommonLayer('mapPrintAddrLayer') });
		
		var comboList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20185"), "");
		$("#addType").html( "<option value=''>선택</option>" + comboList1[2] );
		$("#addType2").html( "<option value=''>선택</option>" + comboList1[2] );
		$("#addType3").html( "<option value=''>선택</option>" + comboList1[2] );
	});

	// 리턴함수
	function setValue(){
		
		var searchTitle = $("#title").val();
		var addType 	= $("#addType").val();
		var addType2 	= $("#addType2").val();
		var addType3 	= $("#addType3").val();
		
		if ( addType == "" ){
			alert('1순위는 반드시 선택해 주십시오.');
			return;
		}
		
		if ( addType3 != "" && addType2 == "" ){
			
			alert('3순위를 선택했으면, 2순위도 선택해야 합니다.');
			return;
		}
		
		if ( searchTitle == "" ){
			alert("제목은 필수입력 사항입니다");
			return;
		}
		
		if ( addType2 != "" && ( addType == addType2) ){
			alert("동일한 생성 우선순위를 지정할 수 없습니다.");
			return;
		}
		
		if ( addType3 != "" && ( addType == addType3) ){
			alert("동일한 생성 우선순위를 지정할 수 없습니다.");
			return;
		}
		
		if ( addType2 != "" && addType3 != "" && ( addType2 == addType3) ){
			alert("동일한 생성 우선순위를 지정할 수 없습니다.");
			return;
		}
		
		var data = ajaxCall("${ctx}/MapPrintAddr.do?cmd=saveMapAddrByRecord", "title=" + searchTitle + "&addType=" + addType + "&addType2=" + addType2 + "&addType3=" + addType3 , false);
		
		if ( data.Result["Code"] == "1" ) {
			
			alert("<msg:txt mid='alertSaveOkV1' mdef='저장 되었습니다.'/>");
			var returnValue = new Array(1);
			
			returnValue["title"] = searchTitle;

			const modal = window.top.document.LayerModalUtility.getModal('mapPrintAddrLayer');
			modal.fire('mapPrintAddrLayerTrigger', returnValue).hide();


		}else{
			alert(data.Result["Message"]);
		}
	}
	
</script>
</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
		<div class="modal_body">
			<form id="sheet1Form" name="sheet1Form">
				<input id="authPg" name="authPg" type="hidden" value="" />
				<table class="table">
					<tbody>
						<colgroup>
							<col width="20%" />
							<col width="75%" />
						</colgroup>
						<tr>
							<td colspan="2">
								※ 입력한 [주소록 명칭]으로 [생성 우선순위]에 따라 주소록이 생성됩니다.
							</td>
						</tr>
						<tr>
							<th align="center">주소록 명칭</th>
							<td class="content">
								<input id="title" name="title" class="required w100p" type="text" />
							</td>
						</tr>
						<tr>
							<th align="center">생성 우선순위</th>
							<td class="content">
								&nbsp;&nbsp;1순위
								<select id="addType" name="addType" class="box w20p required"></select>
								&nbsp;&nbsp;|&nbsp;&nbsp;
								2순위
								<select id="addType2" name="addType2" class="box w20p "></select>
								&nbsp;&nbsp;|&nbsp;&nbsp;
								3순위
								<select id="addType3" name="addType3" class="box w20p "></select>
							</td>
						</tr>

					</tbody>
				</table>
			</form>
		</div>
		<div class="modal_footer">
			<span id="closeYn" class="">
				<a href="javascript:setValue();"	class="btn filled"><tit:txt mid='114525' mdef='생성'/></a>
				<a class="btn outline_gray close"><tit:txt mid='104157' mdef='닫기'/></a>
			</span>
		</div>
	</div>
</body>
</html>
