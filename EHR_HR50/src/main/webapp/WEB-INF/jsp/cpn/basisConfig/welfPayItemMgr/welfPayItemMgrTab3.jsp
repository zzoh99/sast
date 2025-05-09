<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title><tit:txt mid='114494' mdef='복리후생급여항목코드 '/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
</head>
<body class="hidden">
<div class="wrapper">
	 	<div class="explain">
		<div class="title">세팅방법</div>
		<div class="txt">
1. [복리후생 > 복리후생마감 > 급여연계처리기준관리 > 복리후생마감코드관리] : 복리후생업무구분코드(B10230)와 마감관리코드(S90001)를 등록합니다.<br />
마감관리코드(S90001)는 급여계산시 마감될 항목입니다.<br />
복리후생업무구분코드(B10230)는 복리후생연계처리에서 사용할 업무구분코드입니다.<br />
2. [복리후생 > 복리후생마감 > 급여연계처리기준관리 > 복리후생급여항목코드] : 복리후생업무구분코드(B10230)와 급여항목(수당 및 공제)을 연결합니다.<br />
   체크가 된 항목이 합산이 됩니다.<br />
   예를 들어, 복리후생업무구분코드(B10230)의 건강보험 항목이 건강보험과 건강보험정산, 건강보험환급이자로만 급여항목에서 공제된다면<br />
   노인장기요양보험을 건강보험 항목에 합산해서 지급해야 합니다.이 때 관련된 금액 칸에 체크를 하게되면 합산해서 지급하게 됩니다.<br />
3. [복리후생 > 복리후생마감 > 급여연계처리기준관리 > 급여마감항목관리] : 급여구분별로 마감관리코드(S90001)를 등록합니다. 이 때, 복리후생업무구분코드(B10230)을<br />
   등록하면 2번에서 체크된 금액이 합산되어 급여계산시 지급 또는 공제됩니다. <br />
   단, 변동급여칸에 체크를 하게 되면, [복리후생 > 복리후생마감 > 변동급여업로드]에 해당 항목이 활성화되면서 금액을 입력할 수 있고, 이를 급여계산시 활용할 수<br />
   있습니다.<br />
4. [복리후생 > 복리후생마감 > 급여연계처리기준관리 > 복리후생담당자관리] : 복리후생 업무에 맞게 담당자를 등록하게되면 [복리후생 > 복리후생마감 > 변동급여업로드] 및<br />
   [복리후생 > 복리후생마감 > 변동급여담당자마감], [복리후생 > 복리후생마감 > 복리후생이력생성결과(담당자)]에서 권한에 맞게 업무를 처리할 수 있습니다.
		</div>
	</div>
</div>
</body>
</html>