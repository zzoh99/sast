<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><tit:txt mid='104100' mdef='이수시스템(주)'/></title>
<link rel="stylesheet" href="/common/css/dotum.css" />
<link rel="stylesheet" href="/common/theme1/css/style.css" />
<script src="/common/js/jquery/1.8.3/jquery.min.js" type="text/javascript" charset="utf-8"></script>
<script src="/common/js/ui/1.10.0/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>
<script src="/common/js/jquery/jquery.defaultvalue.js" type="text/javascript" charset="utf-8"></script>

 
<!--   VALIDATION	 -->

<script src="/common/js/common.js"		type="text/javascript" charset="utf-8"></script>
<script>
	$(function() {
		$("#input0").keyup(function() {
			makeNumber(this,'A')
		});
		$("#input0").keyup(function() {
			makeNumber(this,'B')
		});
		$("#input0").keyup(function() {
			makeNumber(this,'C')
		});
		$("#input0").keyup(function() {
			makeNumber(this,'D')
		});
		$('[placeholder]').defaultValue();
	});
</script>
<style>
table {margin-bottom:15px;}
caption {text-align:left;font-size:13px;font-weight:bold;}
th {text-align:left;padding:10px 0 0 0;}
td {padding:10px;}
p {margin:10px 0 0 0}
</style>
<body>
<h3><tit:txt mid='103848' mdef='### 입력폼 ###'/></h3>
<br />
<br />

<table>
<caption>1. Input:text</caption>
<tr>
	<td>
	<input type="text" value="입력" class="text" />
	<p><tit:txt mid='104149' mdef='&lt;input type="text" value="입력" class="text" /&gt;'/></p>
	</td>
	<td>
	<input type="text" value="입력" class="text center" />
	<p><tit:txt mid='104337' mdef='&lt;input type="text" value="입력" class="text center" /&gt;'/></p>
	</td>
	<td>
	<input type="text" value="입력" class="text right" />
	<p><tit:txt mid='104437' mdef='&lt;input type="text" value="입력" class="text right" /&gt;'/></p>
	</td>
</tr>
<tr>
	<td>
	<input type="text" value="입력" class="text required" />
	<p><tit:txt mid='104245' mdef='&lt;input type="text" value="입력" class="text required" /&gt;'/></p>
	</td>
	<td>
	<input type="text" value="입력" class="text center required" />
	<p><tit:txt mid='104246' mdef='&lt;input type="text" value="입력" class="text center required" /&gt;'/></p>
	</td>
	<td>
	<input type="text" value="입력" class="text right required" />
	<p><tit:txt mid='103952' mdef='&lt;input type="text" value="입력" class="text  rightrequired" /&gt;'/></p>
	</td>
</tr>
<tr>
	<td>
	<input type="text" value="입력" class="text readonly" />
	<p><tit:txt mid='103953' mdef='&lt;input type="text" value="입력" class="text readonly" /&gt;'/></p>
	</td>
	<td>
	<input type="text" value="입력" class="text center readonly" />
	<p><tit:txt mid='103849' mdef='&lt;input type="text" value="입력" class="text center readonly" /&gt;'/></p>
	</td>
	<td>
	<input type="text" value="입력" class="text right readonly" />
	<p><tit:txt mid='104438' mdef='&lt;input type="text" value="입력" class="text right readonly" /&gt;'/></p>
	</td>
</tr>
<tr>
	<td>
	<input type="text" value="입력" class="text transparent" />
	<p><tit:txt mid='103852' mdef='&lt;input type="text" value="입력" class="text transparent" /&gt;'/></p>
	</td>
	<td>
	<input type="text" value="입력" class="text center transparent" />
	<p><tit:txt mid='104439' mdef='&lt;input type="text" value="입력" class="text center transparent" /&gt;'/></p>
	</td>
	<td>
	<input type="text" value="입력" class="text right transparent" />
	<p><tit:txt mid='104150' mdef='&lt;input type="text" value="입력" class="text right transparent" /&gt;'/></p>
	</td>
</tr>
</table>

<table>
<caption>2. select</caption>
<tr>
	<td>
		<select>
			<option><tit:txt mid='103895' mdef='전체'/></option>
		</select>
		<p>
		&lt;select&gt;<br />
			&lt;option&gt;전체&lt;/option&gt;<br />
		&lt;/select&gt;
		</p>
	</td>
	<td>
		<select disabled="disabled">
			<option><tit:txt mid='103895' mdef='전체'/></option>
		</select>
		<p>
		&lt;select disabled="disabled"&gt;<br />
			&lt;option&gt;전체&lt;/option&gt;<br />
		&lt;/select&gt;
		</p>
	</td>
</tr>
</table>

<table style="width:300px;">
<caption>3. checkbox, radio</caption>
<tr>
	<td>
		<input type="checkbox" />
		<input type="radio" />
	</td>
</tr>
</table>

<table>
<caption>4. textarea</caption>
<tr>
	<td>
		<textarea><tit:txt mid='104429' mdef='내용'/></textarea>
		<p>
		&lt;textarea&gt;내용&lt;/textarea&gt;
		</p>
	</td>
	<td>
		<textarea disabled="disabled" class="readonly"><tit:txt mid='104429' mdef='내용'/></textarea>
		<p>
		&lt;textarea disabled="disabled" class="readonly"&gt;내용&lt;/textarea&gt;
		</p>
	</td>
</tr>
</table>

<b><tit:txt mid='104247' mdef='### 기본값 ###'/></b><br/><br/>
<input class="text" placeholder="기본값" /><br/><br/><br/>

<b><tit:txt mid='103853' mdef='### 입력제한 ###'/></b><br/><br/>

class에 date와 onKeyup 이벤트를 추가하면 입력값을 제한할 수 있습니다.<br/><br/>
<input id="input0" class="text date" /> &lt;input class="text <span class="tPink">date</span>" /&gt;
<br/>
// 숫자만 입력<br/>
$("#input0").keyup(function() {<br/>
&nbsp;&nbsp;&nbsp;&nbsp;makeNumber(this,'A')<br/>
});<br/>
<br/><br/>
// 숫자(-부호 포함)<br/>
$("#input0").keyup(function() {<br/>
&nbsp;&nbsp;&nbsp;&nbsp;makeNumber(this,'B')<br/>
});<br/>
<br/><br/>
// 숫자(소수점 포함)<br/>
$("#input0").keyup(function() {<br/>
&nbsp;&nbsp;&nbsp;&nbsp;makeNumber(this,'C')<br/>
});<br/>
<br/><br/>
// 숫자(-부호/소수점 포함)<br/>
$("#input0").keyup(function() {<br/>
&nbsp;&nbsp;&nbsp;&nbsp;makeNumber(this,'D')<br/>
});<br/><br/>


</body>
</html>
