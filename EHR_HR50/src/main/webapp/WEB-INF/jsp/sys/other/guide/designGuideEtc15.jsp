<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><tit:txt mid='104100' mdef='이수시스템(주)'/></title>
<link rel="stylesheet" href="/common/css/dotum.css" />
<link rel="stylesheet" href="/common/theme1/css/style.css" />
<script type="text/javascript" src="/common/js/jquery/1.9.0/jquery.min.js"></script>
<script type="text/javascript" src="/common/js/ui/1.10.0/jquery-ui.min.js"></script>

<!--  COMMON SCRIT -->
<script src="/common/js/common.js"></script>
<script src="/common/js/commonIBSheet.js"></script>
<!--   IBSHEET	 -->
<script type="text/javascript" src="/common/plugin/IBLeaders/Sheet/js/ibsheetinfo.js"></script>
<script type="text/javascript" src="/common/plugin/IBLeaders/Sheet/js/ibsheet.js"></script>
 
<link rel="stylesheet" type="text/css" href="/common/plugin/IBLeaders/Sheet/css/style.css">
<link rel="stylesheet" type="text/css" href="/common/plugin/IBLeaders/Sheet/css/nwe_common.css">

</head>
<body>
<div class="wrapper">
	<table border="0" cellpadding="0" cellspacing="0" class="table">
	<colgroup>
		<col width="15%" />
		<col width="18%" />
		<col width="15%" />
		<col width="18%" />
		<col width="15%" />
		<col width="" />
	</colgroup>
	<tr>
		<th><tit:txt mid='103880' mdef='성명'/></th>
		<td><input type="text" class="text w100p"/></td>
		<th><tit:txt mid='103975' mdef='사번'/></th>
		<td>&nbsp;</td>
		<th><tit:txt mid='104206' mdef='주민등록번호'/></th>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<th><tit:txt mid='113441' mdef='부서'/></th>
		<td colspan="3"></td>
		<th><tit:txt mid='103881' mdef='입사일'/></th>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<th><tit:txt mid='103786' mdef='상태'/></th>
		<td colspan="3"></td>
		<th><tit:txt mid='104090' mdef='퇴사일'/></th>
		<td>&nbsp;</td>
	</tr>
	</table>
	
	<div class="h15"></div>
	
	<div class="sheet_search">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='113322' mdef='년도'/></th>
			<td>
				<input type="text" class="text" />
			</td>
			<th><tit:txt mid='114504' mdef='작업구분'/></th>
			<td>
				<select>
					<option><tit:txt mid='114322' mdef='연말정산'/></option>
				</select>
			</td>
			<td>
				<btn:a css="button" mid='110697' mdef="조회"/>
				<btn:a css="basic" mid='111739' mdef="원천징수영수증"/>
			</td>
		</tr>
		</table>
		</div>
	</div>
	
	<div class="sheet_title">
	<ul>
		<li class="txt"><tit:txt mid='113268' mdef='소득명세'/></li>
	</ul>
	</div>
	
	<table border="0" cellpadding="0" cellspacing="0" class="table">
	<colgroup>
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="12%" />
		<col width="16%" />
		<col width="13%" />
		<col width="" />
	</colgroup>
	<tr>
		<th class="center"><tit:txt mid='103997' mdef='구분'/></th>
		<th class="center"><tit:txt mid='sepCalcBasicMgrAverageIncome1' mdef='급여'/></th>
		<th class="center"><tit:txt mid='sepCalcBasicMgrAverageIncome2' mdef='상여'/></th>
		<th class="center"><tit:txt mid='114323' mdef='인정상여'/></th>
		<th class="center"><tit:txt mid='113269' mdef='행사이익'/></th>
		<th class="center"><tit:txt mid='113640' mdef='조합인출금'/></th>
		<th class="center"><tit:txt mid='113344' mdef='계'/></th>
	</tr>
	<tr>
		<td class="right"><tit:txt mid='112901' mdef='주(현)'/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
	</tr>
	<tr>
		<td class="right"><tit:txt mid='114324' mdef='종(전)'/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
	</tr>
	<tr>
		<td class="right"><tit:txt mid='104481' mdef='합계'/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
	</tr>
	</table>
	
	<div class="sheet_title">
	<ul>
		<li class="txt"><tit:txt mid='113981' mdef='비과세소득'/></li>
	</ul>
	</div>
	
	<table border="0" cellpadding="0" cellspacing="0" class="table">
	<colgroup>
		<col width="10%" />
		<col width="11%" />
		<col width="11%" />
		<col width="11%" />
		<col width="10%" />
		<col width="14%" />
		<col width="10%" />
		<col width="11%" />
		<col width="" />
	</colgroup>
	<tr>
		<th class="center"><tit:txt mid='103997' mdef='구분'/></th>
		<th class="center"><tit:txt mid='114707' mdef='국외근로'/></th>
		<th class="center"><tit:txt mid='114325' mdef='출산보육'/></th>
		<th class="center"><tit:txt mid='112225' mdef='야간근로'/></th>
		<th class="center"><tit:txt mid='114562' mdef='외국인'/></th>
		<th class="center"><tit:txt mid='113270' mdef='연구보조비'/></th>
		<th class="center"><tit:txt mid='113271' mdef='지정'/></th>
		<th class="center"><tit:txt mid='112902' mdef='그밖의 비과세'/></th>
		<th class="center"><tit:txt mid='113344' mdef='계'/></th>
	</tr>
	<tr>
		<td class="right"><tit:txt mid='112901' mdef='주(현)'/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
	</tr>
	<tr>
		<td class="right"><tit:txt mid='114324' mdef='종(전)'/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
	</tr>
	<tr>
		<td class="right" colspan="4""><tit:txt mid='114708' mdef='비과세총계'/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
	</tr>
	</table>
	
	<div class="sheet_title">
	<ul>
		<li class="txt"><tit:txt mid='112226' mdef='세액명세'/></li>
	</ul>
	</div>
	
	<table border="0" cellpadding="0" cellspacing="0" class="table">
	<colgroup>
		<col width="12%" />
		<col width="13%" />
		<col width="11%" />
		<col width="11%" />
		<col width="15%" />
		<col width="" />
	</colgroup>
	<tr>
		<th colspan="2" class="center"><tit:txt mid='103997' mdef='구분'/></th>
		<th class="center"><tit:txt mid='103981' mdef='소득세'/></th>
		<th class="center"><tit:txt mid='103983' mdef='주민세'/></th>
		<th class="center"><tit:txt mid='114576' mdef='농어촌특별세'/></th>
		<th class="center"><tit:txt mid='113344' mdef='계'/></th>
	</tr>
	<tr>
		<td colspan="2" class="right"><tit:txt mid='103987' mdef='결정세액'/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
	</tr>
	<tr>
		<td class="right" rowspan="2"><tit:txt mid='113272' mdef='기납부 세액'/></td>
		<td class="right"><tit:txt mid='114709' mdef='종(전)근무지'/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
	</tr>
	<tr>
		<td class="right"><tit:txt mid='112904' mdef='주(현)근무지'/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
	</tr>
	<tr>
		<td colspan="2" class="right"><tit:txt mid='114328' mdef='차감징수세액'/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
		<td><input type="text" class="text w100p"/></td>
	</tr>
	</table>

	<div class="h15"></div>
	
		<table border="0" cellpadding="0" cellspacing="0" class="table">
	<colgroup>
		<col width="13%" />
		<col width="17%" />
		<col width="18%" />
		<col width="17%" />
		<col width="" />
		<col width="" />
	</colgroup>
	<tr>
		<th colspan="4" class="center"><tit:txt mid='103997' mdef='구분'/></th>
		<th class="center"><tit:txt mid='112555' mdef='입력금액'/></th>
		<th class="center"><tit:txt mid='112801' mdef='공제금액'/></th>
	</tr>
	<tr>
		<th colspan="4"><tit:txt mid='113986' mdef='총 급 여( 과세대상급여 )'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="4"><tit:txt mid='113273' mdef='근로소득공제'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="4"><tit:txt mid='113274' mdef='근로소득금액'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th rowspan="3"><tit:txt mid='112905' mdef='기본공제'/></th>
		<th colspan="2"><tit:txt mid='114710' mdef='본 인'/></th>
		<td></td>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='113645' mdef='배우자'/></th>
		<td></td>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='114711' mdef='부양가족'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th rowspan="5"><tit:txt mid='113987' mdef='추가공제'/></th>
		<th colspan="2"><tit:txt mid='112906' mdef='경로우대(70세이상)'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='113988' mdef='장애인'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='113989' mdef='부녀자'/></th>
		<td></td>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='112556' mdef='자녀양육비(6세이하)'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='114712' mdef='출산ㆍ입양자'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="3"><tit:txt mid='112557' mdef='다자녀추가공제'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th rowspan="3"><tit:txt mid='perPayMasterMgrException2' mdef='공제'/></th>
		<th colspan="2"><tit:txt mid='112228' mdef='국민연금보험료'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='113275' mdef='기타연금보험료'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='114713' mdef='퇴직연금소득공제'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th rowspan="23"><tit:txt mid='112558' mdef='특별공제'/></th>
		<th rowspan="4"><tit:txt mid='104492' mdef='보험료'/></th>
		<th><tit:txt mid='114329' mdef='건강보험료'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='104380' mdef='고용보험료'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='113646' mdef='보장성보험'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='114330' mdef='장애인전용'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th rowspan="4"><tit:txt mid='113990' mdef='의료비'/></th>
		<th><tit:txt mid='113991' mdef='본인ㆍ65세이상자ㆍ장애인'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td rowspan="4"><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='113992' mdef='그 밖의 공제대상자'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='112908' mdef='노인장기요양(재가급여)'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='113647' mdef='노인장기요양(시설급여)'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th rowspan="5"><tit:txt mid='eduEventMgrPopV6' mdef='교육비'/></th>
		<th><tit:txt mid='113919' mdef='본인'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td rowspan="5"><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='114714' mdef='취학전아동'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='114715' mdef='초ㆍ중ㆍ고'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='113276' mdef='대학생'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='113988' mdef='장애인'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th rowspan="8"><tit:txt mid='112559' mdef='주택자금'/></th>
		<th rowspan="2"><tit:txt mid='113994' mdef='주택임차차입금'/></th>
		<th><tit:txt mid='114335' mdef='원리금상환액(대출기관)'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='114336' mdef='원리금상환액(거주자)'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='112909' mdef='월세액'/></th>
		<th><tit:txt mid='113651' mdef='지출액'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th rowspan="5"><tit:txt mid='114337' mdef='장기주택저당차입금'/></th>
		<th><tit:txt mid='113652' mdef='2011년 이전(15년미만)'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='113653' mdef='2011년 이전(15년~29년)'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='113654' mdef='2011년 이전(30년이상)'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='114718' mdef='2012년 이후(고정금리/비거치상환)'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='114338' mdef='2012년 이후(기타 대출)'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='114339' mdef='기부금'/></th>
		<td></td>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="4"><tit:txt mid='114340' mdef='계 (또는 표준공제)'/></th>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="5"><tit:txt mid='113281' mdef='차감소득금액'/></th>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th rowspan="21"><tit:txt mid='112231' mdef='소득공제'/></th>
		<th rowspan="2"><tit:txt mid='113282' mdef='연금저축'/></th>
		<th><tit:txt mid='112910' mdef='개인연금저축'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='113282' mdef='연금저축'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='113995' mdef='소기업ㆍ소상공인 공제부금 소득공제'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th rowspan="4"><tit:txt mid='113283' mdef='주택마련저축'/></th>
		<th><tit:txt mid='112564' mdef='청약저축'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td rowspan="4"><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='112565' mdef='주택청약종합저축'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='112566' mdef='장기주택마련저축'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='113655' mdef='근로자주택마련저축'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th rowspan="3" ><tit:txt mid='112232' mdef='투자조합 출자공제'/></th>
		<th ><tit:txt mid='113656' mdef='2011년 이전 출자'/></th>
		<td>&nbsp;</td>
		<td><input type="text" class="text w100p" /></td>
		<td rowspan="3" ><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='112567' mdef='2012년 이후 출자(벤처기업 투자분 제외)'/></th>
		<td>&nbsp;</td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='112568' mdef='2012년 이후 출자(벤처기업 투자분)'/></th>
		<td>&nbsp;</td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th rowspan="6"><tit:txt mid='112231' mdef='소득공제'/></th>
		<th><tit:txt mid='113657' mdef='신용카드 등'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td rowspan="6" ><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='112911' mdef='현금영수증'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='114720' mdef='학원비 지로납부'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='113658' mdef='직불카드 등'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='112233' mdef='전통시장사용분'/></th>
		<td></td>               
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='112912' mdef='사업관련비용'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='113659' mdef='우리사주조합 소득공제'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th rowspan="3"><tit:txt mid='113285' mdef='장기주식형저축소득공제'/></th>
		<th><tit:txt mid='113999' mdef='납입 1년차'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td rowspan="3"><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='114000' mdef='납입 2년차'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='112570' mdef='납입 3년차'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='112237' mdef='고용유지 중소기업 근로자 소득공제'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="4"><tit:txt mid='113286' mdef='그 밖의 소득공제 계'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td></td>
	</tr>
	<tr>
		<th colspan="5"><tit:txt mid='114723' mdef='종합소득 과세표준'/></th>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="5"><tit:txt mid='104482' mdef='산출세액'/></th>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th rowspan="5"><tit:txt mid='114342' mdef='세액감면'/></th>
		<th colspan="2" ><tit:txt mid='114343' mdef='소득세법'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='112915' mdef='조세특례제한법(제30조 제외)'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='113660' mdef='조세특례제한법 제30조'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='112916' mdef='조세조약'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="4"><tit:txt mid='114724' mdef='세액감면 계'/></th>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th rowspan="7"><tit:txt mid='114725' mdef='세액공제'/></th>
		<th colspan="2"><tit:txt mid='112917' mdef='근로소득'/></th>
		<td></td>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='114344' mdef='납세조합공제'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='114726' mdef='주택차입금'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="2"><tit:txt mid='114001' mdef='기부정치자금'/></th>
		<td></td>
		<td><input type="text" class="text w100p" /></td>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="2" rowspan="2"><tit:txt mid='114345' mdef='외국납부'/></th>
		<th><tit:txt mid='114002' mdef='소득금액'/></th>
		<td><input type="text" class="text w100p" /></td>
		<td rowspan="2"><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th><tit:txt mid='113287' mdef='납부세액'/></th>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="4"><tit:txt mid='112571' mdef='세액공제계'/></th>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	<tr>
		<th colspan="5"><tit:txt mid='103987' mdef='결정세액'/></th>
		<td><input type="text" class="text w100p" /></td>
	</tr>
	</table>

</div>

</body>
</html>
