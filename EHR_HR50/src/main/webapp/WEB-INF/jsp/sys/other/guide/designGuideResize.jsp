<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><tit:txt mid='104100' mdef='이수시스템(주)'/></title>
<link rel="stylesheet" href="/common/css/dotum.css" />
<link rel="stylesheet" href="/common/theme1/css/style.css" />
<style>
table {margin-bottom:15px;}
caption {text-align:left;font-size:13px;font-weight:bold;margin-bottom:10px;}
th {text-align:left;padding:10px 0 0 0;}
td {padding:10px;line-height:18px}
p {margin:10px 0 0 0}
span.aqua {color:#1f9aa9}
span.green {color:#b38833}
span.blue {color:#45a3e6}
</style>
<body>
<h3><tit:txt mid='104341' mdef='### sheet 리사이즈 ###'/></h3>
<br />
<br />
자동으로 시트의 높이를 화면에 맞도록 맞추는 것은 불가능하다<br />
그래서 각 페이지에 접속할때와 화면이 리사이즈가 될때 시트의 높이를 계산해서 화면에 맞춰주는데<br />
약간의 규칙이 있다.<br /><br />

그 규칙은 outer, inner 클래스를 넣은 부분을 빼고 시트의 높이를 맞추는 것이다.<br />
단 outer 클래스는 위치가 상관없지만 inner 클래스는 시트와 같은 레벨에 위치해야 한다.
<br /><br /><br />
<b><tit:txt mid='104153' mdef='높이 계산 규칙'/></b><br /><br /><br />
<span style="border:1px solid;padding:10px;background:#eee">
<span class="aqua"><tit:txt mid='103956' mdef='시트'/></span><tit:txt mid='104154' mdef='높이 = 전체높이 - '/><span class="blue"><tit:txt mid='104442' mdef='검색폼(class="outer")'/></span><tit:txt mid='104251' mdef='높이 - '/><span class="green"><tit:txt mid='104053' mdef='타이틀, 버튼(class="inner")'/></span>높이
</span>
<br />
<br />
<br />
<table border="1">
<caption>화면1</caption>
<tr>
	<td><span class="blue"><tit:txt mid='104442' mdef='검색폼(class="outer")'/></span></td>
</tr>
<tr>
	<td>
		<span class="green"><tit:txt mid='104053' mdef='타이틀, 버튼(class="inner")'/></span><br/>
		<span class="aqua"><tit:txt mid='104443' mdef='시트 (width=100%,height=100%)'/></span>
	</td>
</tr>
</table>
<br />
이렇게 위치했을 경우 시트는 문서 전체 높이에서 outer과 inner 클래스영역의 높이를 뺀 나머지 높이를 갖게 된다<br />

outer은 공통으로 사용하는 부분에 outer을 넣어주면 되고 inner은 해당 시트만 사용하는 영역이다. <br /><br />


<table border="1">
<caption>화면2x1</caption>
<tr>
	<td colspan="2"><span class="blue"><tit:txt mid='104442' mdef='검색폼(class="outer")'/></span></td>
</tr>
<tr>
	<td>
		<span class="green"><tit:txt mid='104053' mdef='타이틀, 버튼(class="inner")'/></span><br/>
		<span class="aqua"><tit:txt mid='104255' mdef='시트 (width=50%,height=100%)'/></span>
	</td>
	<td>
		<span class="green"><tit:txt mid='104053' mdef='타이틀, 버튼(class="inner")'/></span><br/>
		<span class="aqua"><tit:txt mid='104255' mdef='시트 (width=50%,height=100%)'/></span>
	</td>
</tr>
</table>
<br />
<table border="1">
<caption>화면1x2</caption>
<tr>
	<td><span class="blue"><tit:txt mid='104442' mdef='검색폼(class="outer")'/></span></td>
</tr>
<tr>
	<td>
		<span class="green"><tit:txt mid='104053' mdef='타이틀, 버튼(class="inner")'/></span><br/>
		<span class="aqua"><tit:txt mid='104551' mdef='시트 (width=100%,height=50%)'/></span>
	</td>
</tr>
<tr>
	<td>
		<span class="green"><tit:txt mid='104053' mdef='타이틀, 버튼(class="inner")'/></span><br/>
		<span class="aqua"><tit:txt mid='104551' mdef='시트 (width=100%,height=50%)'/></span>
	</td>
</tr>
</table>

</body>
</html>
