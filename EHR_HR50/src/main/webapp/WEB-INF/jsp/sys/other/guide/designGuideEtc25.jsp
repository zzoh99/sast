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
<script src="/common/js/jquery/datepicker_lang_KR.js"	type="text/javascript" charset="utf-8"></script>
<script src="/common/js/jquery/jquery.datepicker.js" type="text/javascript" charset="utf-8"></script>


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
		mySheet0.SetConfig(cfg);
		mySheet1.SetConfig(cfg);
		
		var cols = [
			
			{Type:"Seq",    Hidden:0, 	Width:"45",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Type:"DelCheck",	Hidden:0,	Width:"45",	Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Type:"Result",   Hidden:1,	Width:"45",	Align:"Center",  ColMerge:0,   SaveName:"sResult" },
			{Type:"Status",   Hidden:0,	Width:"45",	Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Type:"Text",    	Hidden:1,   		Width:0,   			Align:"Left",    ColMerge:0,   SaveName:"viewCd",    KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Type:"Text",    	Hidden:0,   		Width:200,  		Align:"Left",    ColMerge:0,   SaveName:"viewNm",    KeyField:1,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Type:"Text",    	Hidden:0,   		Width:60,   		Align:"Right",   ColMerge:0,   SaveName:"seq",       KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Type:"Text",    	Hidden:0,   		Width:220,			Align:"Left",    ColMerge:0,   SaveName:"viewDesc",  KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 }
		
		];
		
		var headers = [
			{Text:"No|삭제|결과|상태|View코드|View명|순서|View설명", Align:"Center"}
		];

		mySheet0.InitHeaders(headers);
		mySheet0.InitColumns(cols);
		mySheet0.SetCountPosition(4);
		mySheet0.DataInsert();

		mySheet1.InitHeaders(headers);
		mySheet1.InitColumns(cols);
		mySheet1.SetCountPosition(4);
		mySheet1.DataInsert();
		
	    $(window).smartresize(sheetResize);
	    
	    sheetInit();
	    
	    $( "#date" ).datepicker2();
	});
</script>

</head>
<body class="bodywrap">
<div class="wrapper">
	
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="50%" />
		<col width="50%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='orgNm' mdef='조직'/></li>
					<li class="btn">
						<btn:a css="button" mid='110697' mdef="조회"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("mySheet0", "50%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='orgEmpNm' mdef='조직원'/></li>
					<li class="btn">
						<btn:a css="button" mid='110697' mdef="조회"/>
					</li>
				</ul>
				</div>
			</div>
			
			<script type="text/javascript"> createIBSheet("mySheet1", "50%", "100%", "${ssnLocaleCd}"); </script>
			
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='pictureReg' mdef='사진등록'/></li>
				</ul>
				</div>
			</div>
			
			<table border="0" cellpadding="0" cellspacing="0" class="default inner fixed">
			<colgroup>
				<col width="" />
				<col width="20%" />
				<col width="" />
			</colgroup>
			<tr>
				<td rowspan="3" class="photo"><img src="/common/images/common/img_default_photo.jpg"/></td>
				<th><tit:txt mid='103975' mdef='사번'/></th>
				<td>31101410</td>
			</tr>
			<tr>
				<th><tit:txt mid='103880' mdef='성명'/></th>
				<td></td>
			</tr>
			<tr>
				<td colspan="2" class="h40">
					- 파일명 : 영문, 숫자만 지원합니다.<br/>
					- 사이즈 : 85px * 113px 입니다.<br/>
					- 확장자 : gif, jpg 만 가능합니다.<br/>
					- 확장자만 다른 파일을 업로드해서 (ex) aa.jpg, aa.gif<br/>
					- 파일리스트에 2개의 파일이 있을 경우 파일 하나를 삭제하시면 됩니다.
				</td>
			</tr>
			</table>
			
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">
						<input type="file" class="text w200" />
					</li>
					<li class="btn">
						<btn:a css="basic" mid='111575' mdef="파일추가"/>
						<btn:a css="basic" mid='110826' mdef="파일삭제"/>
						<btn:a css="basic" mid='110698' mdef="다운로드"/>
					</li>
				</ul>
				</div>
			</div>
					
		</td>
	</tr>
	</table>
	
</div>
</body>
</html>
