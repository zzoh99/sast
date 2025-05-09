<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="../common/include/session.jsp"%>
<%
	// 본 파일은 yeaDataPrtView.jsp에서 참조됩니다.
	/* 20240117 START
	[ 급여관리 > 연말정산_2023 > 소득공제자료관리 > 자료등록 > (탭) 출력 ]
	  최초에 메뉴 클릭 당시에만 securityMgr2.jsp에서 SecurityKey가 발급되어서
	  동일 화면에서 "소득공제서", "신용카드등", "기부금명세서", "의료비명세서" 버튼을 시간차를 두고 클릭하면
	  [ 시스템사용기준관리 ]에서 보안을 체크하는 사이트는 SecurityKey 만료로 자료가 조회되지 않음.
	 => 버튼 클릭 때마다 재처리토록 수정 */
    response.setContentType("application/json"); // 응답시 json 타입이라는 걸 명시 ( 안해주면 json 타입으로 인식하지 못함 )
	out.print("{\"securityKey\":\"" + request.getAttribute("securityKey") + "\"}"); // json 형식으로 출력
%>