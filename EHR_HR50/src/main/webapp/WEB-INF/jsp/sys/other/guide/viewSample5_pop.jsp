<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><tit:txt mid='appComLayout' mdef='신청'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>


<script type="text/javascript">
	/*Sheet 기본 설정 */
	$(function() {

		submitCall($("#authorForm"),"authorFrame","post","/html/sample/2_3.html");

	    // 닫기 버튼
	    $(".close").click(function() {
	    	self.close();
	    });
	    // 프린트 버튼
	    $(".print>a").click(function(e) {
	    	e.stopPropagation();
	    });
	});
</script>

<body>
<form name="authorForm" id="authorForm">
</form>

<div class="wrapper popup_scroll">
	<div class="popup_title">
	<ul>
		<li>
			신청 - 공통 레이아웃
		</li>

	</ul>
	</div>

	<div class="popup_main">
		<table border="0" cellpadding="0" cellspacing="0" class="settle">
		<colgroup>
			<col width="15%" />
			<col width="35%" />
			<col width="15%" />
			<col width="" />
		</colgroup>
		<tr>
			<th><tit:txt mid='103918' mdef='제목'/></th>
			<td>
				<input type="text" class="text w100p" />
			</td>
			<th><tit:txt mid='112764' mdef='문서번호'/></th>
			<td>
				20YY-123456
			</td>
		</tr>
		</table>

		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='112935' mdef='신청인'/></li>
		</ul>
		</div>

		<table border="0" cellpadding="0" cellspacing="0" class="settle">
		<colgroup>
			<col width="15%" />
			<col width="35%" />
			<col width="15%" />
			<col width="35%" />
		</colgroup>
		<tr>
			<th><tit:txt mid='112936' mdef='성명(사번)'/></th>
			<td><tit:txt mid='113307' mdef='홍*동(123456)'/></td>
			<th>소속소속</th>
			<td><tit:txt mid='104051' mdef='인사교육팀'/></td>
		</tr>
		<tr>
			<th><tit:txt mid='104104' mdef='직위'/></th>
			<td><tit:txt mid='112588' mdef='부장'/></td>
			<th><tit:txt mid='contact' mdef='연락처'/></th>
			<td></td>
		</tr>
		</table>

		<div class="sheet_title">
		<ul>
			<li class="btn">
				<select>
					<option>1단계 결재선</option>
				</select>
				<btn:a css="basic" mid='111256' mdef="결재선 변경"/>
			</li>
		</ul>
		</div>

		<div class="author_left">
			<table>
			<tr>
				<td>
					<table class="author">
					<tr>
						<th><tit:txt mid='113629' mdef='기안'/></th>
					</tr>
					<tr>
						<td class="name">소속명여덜글자이상두줄</td>
					</tr>
					<tr>
						<td class="status"><tit:txt mid='103785' mdef='직책'/></td>
					</tr>
					<tr>
						<td class="status"><tit:txt mid='103880' mdef='성명'/></td>
					</tr>
					<tr>
						<td class="date">YY.MM.DD</td>
					</tr>
					</table>
				</td>
				<td>
					<div class="arrow">&nbsp;</div>
				</td>
				<td>
					<table class="author">
					<tr>
						<th><tit:txt mid='113201' mdef='결재'/></th>
					</tr>
					<tr>
						<td class="name"><tit:txt mid='104499' mdef='소속명'/></td>
					</tr>
					<tr>
						<td class="status"><tit:txt mid='103785' mdef='직책'/></td>
					</tr>
					<tr>
						<td class="status"><tit:txt mid='103880' mdef='성명'/></td>
					</tr>
					<tr>
						<td class="date">YY.MM.DD</td>
					</tr>
					</table>
				</td>
				<td>
					<div class="arrow">&nbsp;</div>
				</td>
				<td>
					<table class="author">
					<tr>
						<th><tit:txt mid='113975' mdef='합의'/></th>
					</tr>
					<tr>
						<td class="name"><tit:txt mid='104499' mdef='소속명'/></td>
					</tr>
					<tr>
						<td class="status"><tit:txt mid='103785' mdef='직책'/></td>
					</tr>
					<tr>
						<td class="status"><tit:txt mid='103880' mdef='성명'/></td>
					</tr>
					<tr>
						<td class="date">YY.MM.DD</td>
					</tr>
					</table>
				</td>
				<td>
					<div class="arrow">&nbsp;</div>
				</td>
				<td>
					<table class="author">
					<tr>
						<th><tit:txt mid='113201' mdef='결재'/></th>
					</tr>
					<tr>
						<td class="name"><tit:txt mid='104499' mdef='소속명'/></td>
					</tr>
					<tr>
						<td class="status"><tit:txt mid='103785' mdef='직책'/></td>
					</tr>
					<tr>
						<td class="status"><tit:txt mid='103880' mdef='성명'/></td>
					</tr>
					<tr>
						<td class="date">YY.MM.DD</td>
					</tr>
					</table>
				</td>
				<td>
					<table class="author instead">
					<tr>
						<th><tit:txt mid='113201' mdef='결재'/></th>
					</tr>
					<tr>
						<td class="name"><tit:txt mid='104499' mdef='소속명'/></td>
					</tr>
					<tr>
						<td class="status"><tit:txt mid='103785' mdef='직책'/></td>
					</tr>
					<tr>
						<td class="status"><tit:txt mid='103880' mdef='성명'/></td>
					</tr>
					<tr>
						<td class="date">YY.MM.DD</td>
					</tr>
					</table>
				</td>
			</tr>
			</table>
		</div>
		<div class="author_right">
		<table>
		<tr>
			<td>
				<table class="author">
				<tr>
					<th><tit:txt mid='113629' mdef='기안'/></th>
				</tr>
				<tr>
					<td class="name">소속명여덜글자이상두줄</td>
				</tr>
				<tr>
					<td class="status"><tit:txt mid='103785' mdef='직책'/></td>
				</tr>
				<tr>
					<td class="status"><tit:txt mid='103880' mdef='성명'/></td>
				</tr>
				<tr>
					<td class="date">YY.MM.DD</td>
				</tr>
				</table>
			</td>
			<td><div class="arrow">&nbsp;</div></td>
			<td>
				<table class="author">
				<tr>
					<th><tit:txt mid='113201' mdef='결재'/></th>
				</tr>
				<tr>
					<td class="name"><tit:txt mid='104499' mdef='소속명'/></td>
				</tr>
				<tr>
					<td class="status"><tit:txt mid='103785' mdef='직책'/></td>
				</tr>
				<tr>
					<td class="status"><tit:txt mid='103880' mdef='성명'/></td>
				</tr>
				<tr>
					<td class="date">YY.MM.DD</td>
				</tr>
				</table>
			</td>
		</tr>
		</table>
		</div>

		<div class="auto_info">
		<ul>
			<li class="info_txt">* 성명, 날자컬럼에 마우스 오버 시 사번, 시간을 확인 하실 수 있습니다.<br/>* 결재라인 7명 이상 시 두줄형태로 배치됨니다.</li>
			<li class="info_color">
				<span class="box_green"></span> 신청
				<span class="box_blue"></span> 대결
				<span class="box_aqua"></span> 담당.
			</li>
		</ul>
		</div>

		<div class="clear"></div>

		<table border="0" cellpadding="0" cellspacing="0" class="settle">
		<colgroup>
			<col width="15%" />
			<col width="75px" />
			<col width="" />
		</colgroup>
		<tr>
			<th>
				수신참조

			</th>
			<td class="center">
				<btn:a css="cute_basic" mid='111180' mdef="추가/변경"/></td>
			<td>
				팀 성명(사번) / 팀 성명(사번)
			</td>
		</tr>
		</table>

		<iframe id="authorFrame" name="authorFrame" frameborder="0" class="author_iframe" style="height:400px;"></iframe>

		<div class="h15"></div>

		<table border="0" cellpadding="0" cellspacing="0" class="settle">
		<colgroup>
			<col width="15%" />
			<col width="85%" />
		</colgroup>
		<tr>
			<th><tit:txt mid='112999' mdef='결재상태'/></th>
			<td>
				<select>
					<option>임시저장</option>
				</select>
			</td>
		</tr>
		</table>

		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='uploadFile' mdef='첨부파일'/></li>
			<li class="btn">
				<a><img src="/common/images/common/btn_file_add.jpg" class="vmiddle"/></a>
				<btn:a css="basic" mid='110703' mdef="업로드"/>
				<a class="basic"><tit:txt mid='113460' mdef='삭제'/></a>
			</li>
		</ul>
		</div>


		<div class="popup_button">
		<ul>
			<li>
				<btn:a css="gray large" mid='111109' mdef="임시저장"/>
				<btn:a css="pink large" mid='110819' mdef="신청"/>
				<btn:a href="javascript:this.close();" css="gray large" mid='110881' mdef="닫기"/>
			</li>
		</ul>
		</div>
	</div>
</div>
</body>
</html>
