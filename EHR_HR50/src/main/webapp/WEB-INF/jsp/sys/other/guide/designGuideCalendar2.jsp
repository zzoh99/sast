<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><tit:txt mid='104100' mdef='이수시스템(주)'/></title>
<link rel="stylesheet" href="/common/css/dotum.css" />
<link rel="stylesheet" href="/common/theme1/css/style.css" />
<script type="text/javascript" src="/common/js/jquery/1.9.0/jquery.min.js"></script>
<script type="text/javascript" src="/common/js/ui/1.10.0/jquery-ui.min.js"></script>
<script type="text/javascript" src="/common/js/jquery/datepicker_lang_KR.js"></script>
<script type="text/javascript" src="/common/js/jquery/jquery.datepicker.js"></script>



<script type="text/javascript" src="/common/js/common.js"></script>

<script type="text/javascript">
	$(document).ready(function () {
		$( "#date" ).datepicker2();
		
		/*
		startdate : to 아이디를 넣어주세요
		enddate : from 아이디를 넣어주세요
		*/
		$("#fromInputId").datepicker2({startdate:"toInputId"});
		$("#toInputId").datepicker2({enddate:"fromInputId"});

		$("#example0").datepicker2({ymonly:true});
		$("#time").mask("11:11");
		/*
		$( "#from" ).datepicker({
			onClose: function( selectedDate ) {	// 닫을때 이벤트
				$( "#to" ).datepicker( "option", "minDate", selectedDate );
			}
		});
	
		$( "#to" ).datepicker({
			onClose: function( selectedDate ) {
				$( "#from" ).datepicker( "option", "maxDate", selectedDate );
			}
		});
		
		var options = {
			    pattern: 'yyyy-mm',
			    startYear: 2008,
			    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
			};


		$('#example0').monthpicker(options);
		$('#example1').monthpicker(options);
		*/

	});
</script>
<body>
<h3><tit:txt mid='104333' mdef='### 달력 ###'/></h3>
<br />
<br />
1. 단일<br />
<input type="text" id="date" name="date" class="date2"  value="20130401"/><br /><br />

2. from ~ to<br />
<input type="text" id="fromInputId" name="fromInputId" class="date2" value="2013-04-01" /> ~ <input type="text" id="toInputId" name="toInputId" class="date2"  value="2013-04-30"/><br /><br />

3. yyyymm 달력<br/>
<input id="example0" class="date2"><br/><br/>

<input id="time" class="date2"><br/><br/>

<br/>
기타<br/>
<br/><br/>
- 팝업에서 화면 로드후 달력이 자동으로 펼쳐질경우 form에다 tabindex="1" 넣어주면 자동으로 뜨지 않는다.
</body>
</html>
