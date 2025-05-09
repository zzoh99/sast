<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><tit:txt mid='104100' mdef='이수시스템(주)'/></title>
<link rel="stylesheet" href="/common/css/dotum.css" />
<link rel="stylesheet" href="/common/theme1/css/style.css" />

<!--   JQUERY	 -->
<script src="/common/js/jquery/1.9.0/jquery.min.js"></script>
<script src="/common/js/ui/1.10.0/jquery-ui.min.js"></script>

<!--  COMMON SCRIT -->
<script src="/common/js/common.js"></script>
<script src="/common/js/commonIBSheet.js"></script>
<!--   IBSHEET	 -->
<script type="text/javascript" src="/common/plugin/IBLeaders/Sheet/js/ibsheetinfo.js"></script>
<script type="text/javascript" src="/common/plugin/IBLeaders/Sheet/js/ibsheet.js"></script>
 
<link rel="stylesheet" type="text/css" href="/common/plugin/IBLeaders/Sheet/css/style.css">
<link rel="stylesheet" type="text/css" href="/common/plugin/IBLeaders/Sheet/css/nwe_common.css">

<script type="text/javascript">
	/*Sheet 기본 설정 */
	$(function() {
		var cfg = {};
		mySheet.SetConfig(cfg);
		
		var cols = [
			{Type:"Seq",    Hidden:0, 	Width:"45",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Type:"DelCheck",	Hidden:0,	Width:"45",	Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Type:"Text",    	Hidden:0,   		Width:100,  		Align:"Left",    ColMerge:0,   SaveName:"viewNm",    KeyField:1,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Type:"Text",    	Hidden:0,   		Width:60,   		Align:"Right",   ColMerge:0,   SaveName:"seq",       KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Type:"Text",    	Hidden:0,   		Width:120,			Align:"Left",    ColMerge:0,   SaveName:"viewDesc",  KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 }
		];
		
		var headers = [
			{Text:"No|선택|파일명|용량(Byte)|다운로드", Align:"Center"}
		];
		
		mySheet.InitHeaders(headers);
		mySheet.InitColumns(cols);
		
		// submitCall($("#authorForm"),"authorFrame","post","/html/sample/2_3.html");

	    $(window).smartresize(sheetResize);
	    
	    sheetInit();
	    
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
			결재 - 공통 레이아웃
		</li>
		<li class="close">
			<div class="print">
				<btn:a css="basic" mid='110744' mdef="인쇄"/>
			</div>
		</li>
	</ul>
	</div>
	
	<div class="popup_main">
		<table border="0" cellpadding="0" cellspacing="0" class="settle">
		<colgroup>
			<col width="15%" />
			<col width="35%" />
			<col width="15%" />
			<col width="35%" />
		</colgroup>
		<tr>
			<th><tit:txt mid='103918' mdef='제목'/></th>
			<td><tit:txt mid='104429' mdef='내용'/></td>
			<th><tit:txt mid='112764' mdef='문서번호'/></th>
			<td>
				20YY-123456
			</td>
		</tr>
		</table>
		
		<div class="sheet_title">
		<ul>
			<li class="btn">
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
						<td class="name"><tit:txt mid='113973' mdef='조직명여덜글자이상두줄'/></td>
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
						<td class="name"><tit:txt mid='104514' mdef='조직명'/></td>
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
						<td class="name"><tit:txt mid='104514' mdef='조직명'/></td>
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
						<td class="name"><tit:txt mid='104514' mdef='조직명'/></td>
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
						<td class="name"><tit:txt mid='104514' mdef='조직명'/></td>
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
					<td class="name"><tit:txt mid='113973' mdef='조직명여덜글자이상두줄'/></td>
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
					<td class="name"><tit:txt mid='104514' mdef='조직명'/></td>
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
			<li class="info_txt"><tit:txt mid='112148' mdef='* 성명, 날자컬럼에 마우스 오버 시 사번, 시간을 확인 하실 수 있습니다.'/><br/><tit:txt mid='114251' mdef='* 결재라인 7명 이상 시 두줄형태로 배치됨니다.'/></li>
			<li class="info_color">
				<span class="box_green"></span> 신청
				<span class="box_blue"></span> 대결
				<span class="box_aqua"></span> 담당.
			</li>
		</ul>
		</div>
		
		<div class="clear"></div>
		
		<iframe id="authorFrame" name="authorFrame" frameborder="0" class="author_iframe" style="height:400px;"></iframe>
		
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='uploadFile' mdef='첨부파일'/></li>
			<li class="btn">
				<btn:a css="basic" mid='110922' mdef="첨부"/>
				<a class="basic"><tit:txt mid='113460' mdef='삭제'/></a>
			</li>
		</ul>
		</div>

		<script type="text/javascript"> createIBSheet("mySheet", "100%", "80px", "${ssnLocaleCd}"); </script>

		<div class="popup_sub_button">
		<ul>
			<li>
				<btn:a css="pink large" mid='111177' mdef="결재"/>
				<btn:a css="gray large" mid='110821' mdef="반려"/>
			</li>
		</ul>
		</div>

		<table border="0" cellpadding="0" cellspacing="0" class="settle">
		<colgroup>
			<col width="15%" />
			<col width="85%" />
		</colgroup>
		<tr>
			<th><tit:txt mid='112999' mdef='결재상태'/></th>
			<td>
				<select>
					<option><tit:txt mid='113631' mdef='결재중'/></option>
				</select>
			</td>
		</tr>
		</table>
<!--
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='104446' mdef='결재의견'/></li>
		</ul>
		</div>
-->
		<table border="0" cellpadding="0" cellspacing="0" class="settle">
		<colgroup>
			<col width="15%" />
			<col width="85%" />
		</colgroup>
		<tr>
			<th><tit:txt mid='113976' mdef='소속/직책/성명'/></th>
			<td><tit:txt mid='104429' mdef='내용'/></td>
		</tr>
		</table>
		
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='112153' mdef="추가/변경"/></li>
		</ul>
		</div>
		
		<table border="0" cellpadding="0" cellspacing="0" class="settle">
		<colgroup>
			<col width="15%" />
			<col width="85%" />
		</colgroup>
		<tr>
			<th><tit:txt mid='113912' mdef='권한추가자'/></th>
			<th><tit:txt mid='112372' mdef='참조자'/></th>
		</tr>
		<tr>
			<td>
				소속/직책/성명<br />
				<span style="font-size:11px;letter-spacing:-1px">2013.05.10 16:26:01</span>
			</td>
			<td><tit:txt mid='112543' mdef='팀 성명(사번) / ~'/></td>
		</tr>
		</table>

		<div class="popup_button">
		<ul>
			<li>
				<btn:a href="javascript:this.close();" css="gray large" mid='110881' mdef="닫기"/>
			</li>
		</ul>
		</div>
	</div>
</div>
</body>
</html>
