<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="yjungsan.util.*"%>


<script type="text/javascript">
/* 발레오만 우선 적용하기 위해 기본적으로 주석 처리 : 사용할때는 주석 풀어서 적용 - 2020.02.04.
 * 해당 함수는 ibsheetinfo.js 에서 호출하므로 적용을 할때는 ibsheetinfo.js도 수정해서 적용해야 한다
 * /OPTI_YEAR44/WebContent/yjungsan/common_jungsan/plugin/IBLeaders/Sheet/js/ibsheetinfo.js
 */
 /************************************************************* 
 * 2021.04.07 로그관리 
 *  ibsheetinfo.js에서 나는 에러로 주석 해제
 *************************************************************/
function headerReSetTimer() {
	var that = window.top;
	if(that.parent) {
		if(typeof that.parent.resetTimer != 'undefined') {
			that.parent.resetTimer();
		} else {
			if(that.parent.opener) {
				that.parent.opener.headerReSetTimer();
			} else {
				that.parent.headerReSetTimer();
			}
		}
	}
}

</script>
