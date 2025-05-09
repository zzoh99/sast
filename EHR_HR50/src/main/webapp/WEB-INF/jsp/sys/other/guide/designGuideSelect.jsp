<!DOCTYPE html>
<html class="bodywrap">
<head>

<!--   META	 -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Cache-Control" content="no-cache" />
<meta http-equiv="Expires" content="-1" />
<meta http-equiv="Imagetoolbar" content="no" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />

<title><tit:txt mid='104100' mdef='이수시스템(주)'/></title>
<link rel="stylesheet" href="/common/css/dotum.css" />
<link rel="stylesheet" href="/common/theme1/css/style.css" />

<!--   JQUERY	 -->
<script src="/common/js/jquery/1.9.0/jquery.min.js"></script>
<script src="/common/js/ui/1.10.0/jquery-ui.min.js"></script>
<script src="/common/js/jquery/select2.js"></script>

<!--  COMMON SCRIT -->
<script src="/common/js/common.js"></script>
<script src="/common/js/commonIBSheet.js"></script>

<!--   IBSHEET	 -->
<script type="text/javascript" src="/common/plugin/IBLeaders/Sheet/js/ibsheetinfo.js"></script>
<script type="text/javascript" src="/common/plugin/IBLeaders/Sheet/js/ibsheet.js"></script>
 
<link rel="stylesheet" type="text/css" href="/common/plugin/IBLeaders/Sheet/css/style.css">
<link rel="stylesheet" type="text/css" href="/common/plugin/IBLeaders/Sheet/css/nwe_common.css">

<script type="text/javascript">
$(function() {
	 $.fn.select2.defaults.formatSelectionTooBig = function (limit) { return limit + "ê±´ë§ ì íê°ë¥í©ëë¤."; };
	$(document).ready(function() {
		$("#e3").select2({
			placeholder: "ì í"
			//, maximumSelectionSize:2
		});
		$("#e4").select2({
			placeholder: "ì í"
			//, maximumSelectionSize:2
		});
		
		//$("#e3").html("<option value='red'>ë©ë´1</option><option value='green'>ë©ë´2</option>");
	});
});

function send() {
	// alert( getMultiSelectValue($("#e3").val()) );
	alert( $("#e3").val() );
}
</script>

</head>
<body class="bodywrap">

<div class="sheet_search outer">
	<div>
		<table>
			<tr>
				<th>View ëª</th>
				<td>
					<input type="text" class="text" />
				</td>
				<th>View ëª</th>
				<td>
					<select id="e3" multiple="">
						<option value="red">option1</option>
						<option value="green">option2</option>
						<option value="Blue">option3</option>
						<option value="1111">option4</option>
						<option value="2222">option5</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>View ëª</th>
				<td>
					<input type="text" class="text" />
				</td>
				<th>View ëª</th>
				<td>
					<select id="e4" multiple="">
						<option value="red">option1</option>
						<option value="green">option21</option>
						<option value="Blue">option3</option>
						<option value="1111">option4</option>
						<option value="2222">option5</option>
					</select>
				</td>
			</tr>
		</table>
	</div>
</div>
<br/>
// 멀티 셀렉트에 리스트 추가<br/>
$("#select").append("<option><tit:txt mid='103957' mdef='냉무'/></option>");
<br/><br/>
// 멀티 셀렉트 리스트 제거<br/>
$("#select").find("option:contains('옵션1')").remove();	
</body>
</html>
