<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<%@ page import="com.hr.common.util.DateUtil" %>

<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>직무기술서</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<style type="text/css">
</style>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

/*
 * 핵심과업, 자격면허 탭을 제거 함 *
 * 화면 초기로딩속도를 위하여 Search Action뿐만 아니라
 * 스크립트 및, HTML화면 그리는 부분도 모두 주석처리 하였음
 * 다시 살리고자 할 때 참고 할 것 by JSG
 */
var p = eval("${popUpStatus}");

var selectSheet = null;
var arg = p.popDialogArgumentAll();
var searchName = arg["searchName"];

$(function(){
	
	$( "#tabs" ).tabs();
	
	var searchRecruitTitle  = arg["searchRecruitTitle"];
	var searchApplKey  = arg["searchApplKey"];
	var receiveNo  = arg["receiveNo"];
	
	
	$("#searchRecruitTitle").val(searchRecruitTitle);
	$("#searchApplKey").val(searchApplKey);
	$("#searchReceiveNo").val(receiveNo);

	//Cancel 버튼 처리
	$(".close").click(function(){
		p.self.close();
	});
});

function loadValue() {

}

function setValue() {
	var rv = new Array(15);
	p.popReturnValue(rv);
	p.window.close();
}

$(function() {
	
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:6}; 
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	
	initdata.Cols = [
		{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"채용일련번호",      	Type:"Text",  		Hidden:1,   Width:0,    Align:"Left",   ColMerge:0, SaveName:"seq",         	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
		{Header:"지원번호",      		Type:"Text", 		Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"applKey",     	KeyField:1,   CalcLogic:"",   Format:"Number", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
        {Header:"성명",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
        {Header:"한문성명",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"cname",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50},
        {Header:"영문성명",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ename",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50},
        {Header:"성별",				Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sexType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
        {Header:"전화번호",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"telNo",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},
        {Header:"휴대폰",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mobileNo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},
        {Header:"이메일",				Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"mailAddr",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
        //{Header:"주민번호",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"resNo",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13},
        {Header:"생년월일",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"birYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        {Header:"음양\n구분",			Type:"Combo",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"lunType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
        {Header:"결혼\n여부",			Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"wedYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
        {Header:"결혼일",				Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"wedYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        //{Header:"외국인\n여부",		Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"foreignYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
        {Header:"지원분야",			Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sector1Cd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        {Header:"2지망_지원분야",		Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sector2Cd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        //{Header:"희망근무지",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"hopeLocation1",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        //{Header:"희망근무지2",			Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"hopeLocation2",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        {Header:"채용구분",			Type:"Combo",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"stfType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        {Header:"채용경로",			Type:"Combo",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"empType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        {Header:"주민등록\n우편번호",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"zipJumin",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:7},
        {Header:"주민등록\n주소",		Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"addr1Jumin",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500},
        {Header:"주민등록\n주소상세",	Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"addr2Jumin",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500},
        {Header:"부모님 거주지\n우편번호",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"zipParent",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:7},
        {Header:"부모님 거주지\n주소",		Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"addr1Parent",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500},
        {Header:"부모님 거주지\n주소상세",	Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"addr2Parent",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500},
        {Header:"현우편번호",			Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"zip",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:7},
        {Header:"현주소",				Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"addr1",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500},
        {Header:"현주소상세",			Type:"Text",		Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"addr2",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500},
        {Header:"사번",				Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13},
        {Header:"사번생성룰구분",		Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabunType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        {Header:"사원확정여부",		Type:"Combo",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabunYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
        {Header:"채용IF입력여부",		Type:"Combo",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"staffingYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
        {Header:"품의번호",			Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"processNo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},
        {Header:"지원경로코드",		Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"pathCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        {Header:"입사추천자",			Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"recomName",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
        {Header:"접수일",				Type:"Date",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"receiveYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        {Header:"최초계약일",			Type:"Date",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"fconsYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        {Header:"계약시작일",			Type:"Date",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"conSYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        {Header:"계약만료일",			Type:"Date",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"conEYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        {Header:"수습종료일",			Type:"Date",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"traYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        {Header:"발령형태",			Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        {Header:"발령종류",			Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        {Header:"그룹입사일",			Type:"Date",		Hidden:Number("${gempYmdHdn}"),	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"gempYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        {Header:"입사일",				Type:"Date",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        
        //장애
        {Header:"장애여부",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"handicap",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
        //{Header:"장애등급",			Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jangGradeCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        //{Header:"장애구분",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jangType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        //{Header:"장애인번호",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jangNo",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        //{Header:"인정일",				Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"jangYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        
        //보훈
        {Header:"보훈여부",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"bohun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
        //{Header:"보훈\n고용방법",		Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"employmentGb",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
        //{Header:"보훈종류",			Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"bohunCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        //{Header:"보훈번호",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"bohunNo",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:30},
        //{Header:"보훈가족관계",		Type:"Combo",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"famCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        //{Header:"보훈일자",			Type:"Date",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"bohunYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        
        //건강
        {Header:"혈액형",				Type:"Combo",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"bloodCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        //{Header:"신장",				Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ht",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},
        //{Header:"체중",				Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"wt",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},
        //{Header:"시력(좌)",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"eyeL",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},
        //{Header:"시력(우)",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"eyeR",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},
        //{Header:"시력(좌)\n교정",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sightLeftCorr",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},
        //{Header:"시력(우)\n교정",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sightRitghtCorr",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},
        //{Header:"색맹여부",			Type:"Combo",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"daltonismYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},
        
        //기타개인정보
        {Header:"종교코드",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"relCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        {Header:"국가코드",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"nationalCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        //{Header:"취미",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"hobby",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000},
        //{Header:"특기",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"specialityNote",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000},
 
        //병역
        //{Header:"병역구분",			Type:"Combo",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"transferCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        //{Header:"군별",				Type:"Combo",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"armyCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        //{Header:"계급",				Type:"Combo",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"armyGradeCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},
        //{Header:"입대일",				Type:"Date",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"armySYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        //{Header:"제대일",				Type:"Date",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"armyEYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        //{Header:"전역사유",			Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"armyMemo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000},
        //{Header:"면제사유",			Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"armyMajor",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},
        {Header:"군필/면제 구분",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"dutyYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
        
        //사용안함
        
		//{Header:"최종학력",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"acaCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
		//{Header:"학교",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"acaSchNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
		//{Header:"학교코드",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"acaSchCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
		//{Header:"입학년월일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"acaSYmd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
		//{Header:"졸업년월일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"acaEYmd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
		//{Header:"전공명",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"majorNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
		//{Header:"부전공코드",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"minorCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
		//{Header:"부전공명",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"minorNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
		//{Header:"복수전공코드",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"honorsCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
		//{Header:"복수전공명",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"honorsNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
		//{Header:"학점",				Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"acaPoint",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
		//{Header:"학점만점",			Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"acaPointManjum",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
		//{Header:"편입여부",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"entryType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
		//{Header:"주야여부",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
		//{Header:"본분교\n여부",		Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"dType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
		//{Header:"학교소재지코드",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"acaPlaceCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
		//{Header:"학교소재지상세",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"acaPlaceNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
        
		{Header:"비밀번호",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"password",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},
		
        //{Header:"인턴입사발령사번",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabunIntern",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13},
        //{Header:"최종입사발령사번",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13}
	]; 
	
	
	IBS_InitSheet(sheet0, initdata);sheet0.SetEditable("${editable}");sheet0.SetVisible(true);sheet0.SetCountPosition(4);
	 
	//var comboList01  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F90003"), ""); //희망근무지1
	var comboList02  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20460"), ""); //혈액형
	var comboList03  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F10003"), ""); //채용경로
	var comboList04  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20350"), ""); //종교코드
	var comboList05  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20290"), ""); //국가코드
	//var comboList06  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20200"), ""); //병역_병역구분코드
	//var comboList07  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20230"), ""); //병역_군별코드
	//var comboList08  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20220"), ""); //병역_계급코드
	//var comboList09  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20330"), ""); //장애등급코드
	//var comboList010 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20320"), ""); //장애구분
	//var comboList011 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20310"), ""); //보훈종류코드
	var comboList012 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20120"), ""); //가족관계
	var comboList013 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20316"), ""); //고용방법
	var comboList014 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20280"), ""); //현주소소재지
	var comboList015 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20135"), ""); //최종학력
	var comboList016 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20190"), ""); //전공코드
	var comboList017 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F64140"), ""); //학교소재지코드
	// 지원분야  
	//var comboList018 = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getSector1CdList", false).codeList, "");
	
	
	//var comboList019 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H90014"), ""); //어학특기
	//var comboList020 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H90016"), ""); //예능특기
	//var comboList021 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20320"), ""); //장애구분
	
	 
    sheet0.SetColProperty("sexType",       {ComboText:"|남자|여자", ComboCode:"|1|2"} );
    //sheet0.SetColProperty("entryType",     {ComboText:"|Y|N", ComboCode:"|Y|N"} );
    //sheet0.SetColProperty("eType",          {ComboText:"|주간|야간", ComboCode:"|Y|N"} );
    //sheet0.SetColProperty("dType",          {ComboText:"|본교|분교", ComboCode:"|Y|N"} );
    sheet0.SetColProperty("bohun",         {ComboText:"|보훈", ComboCode:"|보훈"} );
    sheet0.SetColProperty("handicap",      {ComboText:"|장애", ComboCode:"|장애"} );
    sheet0.SetColProperty("wedYn",         {ComboText:"|미혼|기혼", ComboCode:"|N|Y"} );
    sheet0.SetColProperty("daltonismYn",   {ComboText:"|N|Y", ComboCode:"|N|Y"} );
    sheet0.SetColProperty("entryType",     {ComboText:"|N|Y", ComboCode:"|N|Y"} );
    sheet0.SetColProperty("foreignYn",     {ComboText:"|N|Y", ComboCode:"|N|Y"} );
    sheet0.SetColProperty("lunType",       {ComboText:"|양|음", ComboCode:"|1|2"} );
    
    sheet0.SetColProperty("hopeLocation1", {ComboText:"|"+comboList01[0],  ComboCode:"|"+comboList01[1]});
    sheet0.SetColProperty("hopeLocation2", {ComboText:"|"+comboList01[0],  ComboCode:"|"+comboList01[1]});
    sheet0.SetColProperty("bloodCd", 		{ComboText:"|"+comboList02[0],  ComboCode:"|"+comboList02[1]});
    sheet0.SetColProperty("empType",		{ComboText:"|"+comboList03[0],  ComboCode:"|"+comboList03[1]});
    sheet0.SetColProperty("relCd", 			{ComboText:"|"+comboList04[0],  ComboCode:"|"+comboList04[1]});
    sheet0.SetColProperty("nationalCd", 		{ComboText:"|"+comboList05[0],  ComboCode:"|"+comboList05[1]});
    sheet0.SetColProperty("transferCd", 		{ComboText:"|"+comboList06[0],  ComboCode:"|"+comboList06[1]});
    sheet0.SetColProperty("armyCd", 			{ComboText:"|"+comboList07[0],  ComboCode:"|"+comboList07[1]});
    sheet0.SetColProperty("armyGradeCd", 	{ComboText:"|"+comboList08[0],  ComboCode:"|"+comboList08[1]});
    sheet0.SetColProperty("jangGradeCd", 	{ComboText:"|"+comboList09[0],  ComboCode:"|"+comboList09[1]});
    sheet0.SetColProperty("jangType", 		{ComboText:"|"+comboList010[0], ComboCode:"|"+comboList010[1]});
    sheet0.SetColProperty("bohunCd", 		{ComboText:"|"+comboList011[0], ComboCode:"|"+comboList011[1]});
    sheet0.SetColProperty("famCd", 			{ComboText:"|"+comboList012[0], ComboCode:"|"+comboList012[1]});
    sheet0.SetColProperty("employmentGb", {ComboText:"|"+comboList013[0], ComboCode:"|"+comboList013[1]});
    sheet0.SetColProperty("addrRegion",		{ComboText:"|"+comboList014[0], ComboCode:"|"+comboList014[1]});
    sheet0.SetColProperty("acaCd", 			{ComboText:"|"+comboList015[0], ComboCode:"|"+comboList015[1]});
    sheet0.SetColProperty("majorCd", 		{ComboText:"|"+comboList016[0], ComboCode:"|"+comboList016[1]});
    sheet0.SetColProperty("acaPlaceCd", 		{ComboText:"|"+comboList017[0], ComboCode:"|"+comboList017[1]});
    
    sheet0.SetColProperty("sector1Cd", {ComboText:"|"+comboList018[0],  ComboCode:"|"+comboList018[1]});
    sheet0.SetColProperty("sector2Cd", {ComboText:"|"+comboList018[0],  ComboCode:"|"+comboList018[1]});
    
    sheet0.SetColProperty("step1Yukryung", {ComboText:"|"+comboList019[0],  ComboCode:"|"+comboList019[1]});
    sheet0.SetColProperty("step1Yuljung", {ComboText:"|"+comboList020[0],  ComboCode:"|"+comboList020[1]});
    
    
	initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:7}; 
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },		
	    {Header:"채용일련번호",	Type:"Text",    Hidden:1,	Width:0,    Align:"Left",    ColMerge:0,	SaveName:"seq",           KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
        {Header:"지원번호",	    Type:"Text",    Hidden:0,	Width:60,  Align:"Center",  ColMerge:0,	SaveName:"applKey",       KeyField:1,   CalcLogic:"",   Format:"Number", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
        //{Header:"코드\n체크",  	Type:"DummyCheck",  Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"codeChk",               KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
        {Header:"순번",	    	Type:"Text",    Hidden:1,	Width:0,		Align:"Center",  ColMerge:0,	SaveName:"famSeq",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
        {Header:"성명",	    	Type:"Text",    Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",	KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },            
        {Header:"관계코드",	    Type:"Combo",   Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"famCd",	KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
        {Header:"가족성명",	    Type:"Text",    Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"famNm",	KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
        {Header:"동거여부",      	Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"famStay",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
        {Header:"나이",	  		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"famAge",	KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:23 },
        {Header:"직위",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"famDuty",	KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
        {Header:"직업",	    	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"famJob",	KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		];
	
	IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		sheet1.SetColProperty("famCd", 		{ComboText:"Y|N", ComboCode:"Y|N"} );
		sheet1.SetColProperty("famStay",	{ComboText:"Y|N", ComboCode:"Y|N"} );
		
	initdata = {};
	initdata.Cfg = {SearchMode:smServerPaging,Page:100,FrozenCol:6}; 
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"회사코드",		Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"enterCd",			KeyField:1,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"일련번호",	    Type:"Text",      	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"seq",				KeyField:1,	CalcLogic:"",	Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13 },
        {Header:"지원번호",	   	Type:"Text",      	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applKey",			KeyField:1,	CalcLogic:"",	Format:"Number",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
        {Header:"성명",	    	Type:"Text",      	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
        //{Header:"학력",	    	Type:"Combo",  		Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"acaCd",           KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
        {Header:"학위",			Type:"Combo",  		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"degreeCd",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
        {Header:"학교코드",		Type:"Text",      	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"schCd",			KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
        {Header:"학교명",			Type:"PopupEdit",   Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"schNm",			KeyField:1,	CalcLogic:"",	Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
        {Header:"입학일",			Type:"Date",     	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"staYmd",			KeyField:0,	CalcLogic:"",	Format:"Ymd",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
        {Header:"졸업일",			Type:"Date",     	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"endYmd",			KeyField:0,	CalcLogic:"",	Format:"Ymd",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
        {Header:"졸업구분",	    Type:"Combo",     	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"graduationCd",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
        {Header:"전공코드",		Type:"Text",      	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"majorCd",			KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
        {Header:"전공명",			Type:"PopupEdit",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"majorNm",			KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
        {Header:"부전공코드",		Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"minorCd",			KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
        {Header:"부전공명",		Type:"PopupEdit",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"minorNm",			KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
        {Header:"복수전공코드",	Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"honorsCd",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
        {Header:"복수전공명",		Type:"PopupEdit",	Hidden:1,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"honorsNm",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
        //{Header:"졸업논문",	    Type:"Text",  		Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"essay",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:600 },
        //{Header:"논문요약",	    Type:"Text",  		Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"essaySummary",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:600 },
        {Header:"학점",			Type:"Float",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"getGrade",		KeyField:0,	CalcLogic:"",	Format:"NullFloat",	PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
        //{Header:"학점만점",	    Type:"Float",     	Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"acaPointManjum",  KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:1,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
        //{Header:"본교여부",	    Type:"Combo",     	Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"eType",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }, 
        {Header:"편입여부",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"transferYn",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
        {Header:"주야여부",		Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"nightYn",			KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
        {Header:"최종학력여부",	Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"finalSchool",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" }            
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
	
		var cobmboList1  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20140"), "");	//학위코드
		var cobmboList3  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F20140"), "");	//졸업부문
		
		sheet2.SetColProperty("degreeCd", {ComboText:"|"+cobmboList1[0], ComboCode:"|"+cobmboList1[1]} );
	    sheet2.SetColProperty("acaYn", {ComboText:"|"+cobmboList3[0], ComboCode:"|"+cobmboList3[1]} );
	    sheet2.SetColProperty("acaType", {ComboText:"|YES|NO", ComboCode:"|Y|N"} );
	    sheet2.SetColProperty("transferYn", {ComboText:"|YES|NO", ComboCode:"|Y|N"} );
	    sheet2.SetColProperty("nightYn", {ComboText:"|주간|야간", ComboCode:"|Y|N"} );
		
	    initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:6}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },		
			{Header:"채용일련번호",	Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"seq",           KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"지원번호",   	Type:"Text",      Hidden:0,  Width:60,  Align:"Center",  ColMerge:0,   SaveName:"applKey",       KeyField:1,   CalcLogic:"",   Format:"Number", 	  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"성명",      	Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"name",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
            {Header:"일련번호",   	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"seqNo",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"자격구분",   	Type:"Combo",     Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"licenseGubun",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"자격증코드",   	Type:"Text",	  Hidden:0,	 Width:80,	 Align:"Center",  ColMerge:0,	SaveName:"licenseCd",	  KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
            {Header:"자격증명",   	Type:"PopupEdit",     Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"licenseNm",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
            {Header:"등급\n(한정자격)",   	Type:"Text",  Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"licenseGrade",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
            {Header:"취득일",    		Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"licSYmd",       KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"만료일",    		Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"licEYmd",       KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"자격번호",  		Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"licenseNo",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
            {Header:"발급처",    		Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"officeNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
            {Header:"비고",      	Type:"Text",      Hidden:1,  Width:70,   Align:"Left",    ColMerge:0,   SaveName:"bigo",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 } 
			]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);
			
		//자격구분
		var comboList4 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20170"), "");
		sheet3.SetColProperty("licenseGubun", {ComboText:comboList4[0], ComboCode:comboList4[1]} );	
		
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:6}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },		
			{Header:"채용일련번호",	Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"seq",           KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"지원번호",	    Type:"Text",      Hidden:0,  Width:60,  Align:"Center",  ColMerge:0,   SaveName:"applKey",       KeyField:1,   CalcLogic:"",   Format:"Number", 	  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"성명",	    	Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"name",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
            {Header:"일련번호",	    Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"seqNo",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"회사명",	    	Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"companyNm",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
           	<c:choose>
    		<c:when test="${ssnEnterCd == 'DGBC'}">
            {Header:"입사년월",	    Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"staYmd",        KeyField:0,   CalcLogic:"",   Format:"Ym",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:7 },
            {Header:"퇴사년월",	    Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"endYmd",        KeyField:0,   CalcLogic:"",   Format:"Ym",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:7 },
    		</c:when>
    		<c:otherwise>
            {Header:"입사년월일",	    Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"staYmd",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"퇴사년월일",	    Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"endYmd",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
    		</c:otherwise>
    	</c:choose>
            {Header:"최종직위",	    Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"담당업무",	    Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"jobNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"최종연봉",	    Type:"Float",     Hidden:0,  Width:70,  Align:"Right",   ColMerge:0,   SaveName:"contract",      KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"퇴직사유",	    Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"retireReason",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"소재지",	    	Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"placeNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 } 
			]; IBS_InitSheet(sheet4, initdata);sheet4.SetEditable("${editable}");sheet4.SetVisible(true);sheet4.SetCountPosition(4);

			initdata = {};
			initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22,FrozenCol:6}; 
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },		
				{Header:"채용일련번호",	Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"seq",            KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
	            {Header:"지원번호",	    Type:"Text",      Hidden:0,  Width:60,  Align:"Center",  ColMerge:0,   SaveName:"applKey",       KeyField:1,   CalcLogic:"",   Format:"Number",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"성명",	    	Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"name",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
	            {Header:"일련번호",	    Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"seqNo",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
	            {Header:"외국어\n구분코드",	Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"foreignCd",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	            {Header:"외국어\n구분명",	Type:"Popup",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"foreignNm",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
	            {Header:"외국어시험",	    Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"fTestCd",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
	            {Header:"응시일",	   		Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"passYmd",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
	            {Header:"등급",	    	Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"passScoresCd",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
	            {Header:"점수",	    	Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"passScores",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
	            {Header:"발급기관",	    Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"passOrg",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },            
	            {Header:"비고",	    	Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"memo",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
	            {Header:"외국어명",	    Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"foreignNo",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
	            {Header:"자격코드",	    Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"batCd",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }
				]; IBS_InitSheet(sheet5, initdata);sheet5.SetEditable("${editable}");sheet5.SetVisible(true);sheet5.SetCountPosition(4);
				 
			var comboList5  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20300"), "");
			
			
		    sheet5.SetColProperty("foreignCd", {ComboText:comboList5[0], ComboCode: comboList5[1]} );
		    
	$(window).smartresize(sheetResize); sheetInit();

	doAction1("Search"); 
	doAction2("Search");
	doAction3("Search");
	doAction4("Search");
	doAction5("Search");
});



function startView() {
	//바디 로딩 완료후 화면 보여줌(로딩과정에서 화면 이상하게 보이는 현상 해결 by JSG)
	$("#tabs").removeClass("hide");
	$(window).smartresize(sheetResize); sheetInit();
	doAction0("Search");
	
}
function clickTabs(sAction) {
	//hide클래스를 없앤 후 시트 리사이즈가 먹지 않는 문제 해결
	$(window).smartresize(sheetResize); sheetInit();
	switch (sAction) {
	case "0":doAction0("Search");	break ;
	case "1":doAction1("Search");	break ;
	case "2":doAction2("Search");	break ;
	case "3":doAction3("Search");	break ;
	case "4":doAction4("Search");	break ;
	case "5":doAction5("Search");	break ;
	}
}


//공통코드 팝업
function commonCodeSearchPopup(grCode) {
	
	if(!isPopup()) {return;}

	pGubun = grCode;
	
	var w		= 440;
	var h		= 520;
	var url		= "/Popup.do?cmd=commonCodePopup";
	var args	= new Array();
	args["grpCd"] = grCode;

	var result = openPopup(url+"&authPg=R", args, w, h);
}


function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "H20120"){
		var famCd		= rv["code"];
		var famCdNm	= rv["codeNm"];

		sheet1.SetCellValue(gPRow, "famCd", famCd);
		sheet1.SetCellValue(gPRow, "famCdNm", famCdNm);
    }else if(pGubun == "H20135"){
		var famAcaCd		= rv["code"];
		var famAcaNm	= rv["codeNm"];

		sheet1.SetCellValue(gPRow, "famAcaCd", famAcaCd);
		sheet1.SetCellValue(gPRow, "famAcaNm", famAcaNm);
    }else if(pGubun == "H20148_0" || pGubun == "H20149_0" || pGubun == "H20150_0") {
    	sheet0.SetCellValue(gPRow, "acaSchCd", rv["code"]);
    	sheet0.SetCellValue(gPRow, "acaSchNm", rv["codeNm"]);		
    }else if(pGubun == "H20148" || pGubun == "H20149" || pGubun == "H20150") {
    	sheet2.SetCellValue(gPRow, "acaSchCd", rv["code"]);
    	sheet2.SetCellValue(gPRow, "acaSchNm", rv["codeNm"]);
    }else if(pGubun == "H20160"){
		sheet3.SetCellValue(gPRow, "licenseCd", rv["code"]);
    	sheet3.SetCellValue(gPRow, "licenseNm", rv["codeNm"]);
    }else if(pGubun == "H20300"){
		var foreignCd		= rv["code"];
		var foreignNm	= rv["codeNm"];

		sheet5.SetCellValue(gPRow, "foreignCd", foreignCd);
		sheet5.SetCellValue(gPRow, "foreignNm", foreignNm);
    }
    
    if( pGubun == "zipBonjuk" ) {
		sheet0.SetCellValue(gPRow, "zipBonjuk",		rv["zip"]);
		sheet0.SetCellValue(gPRow, "addr1Bonjuk",	rv["addr"]);
		sheet0.SetCellValue(gPRow, "addr2Bonjuk",	rv["engAddr"]);
	}
	if( pGubun == "zipJumin" ) {
		sheet0.SetCellValue(gPRow, "zipJumin",		rv["zip"]);
		sheet0.SetCellValue(gPRow, "addr1Jumin",	rv["addr"]);
		sheet0.SetCellValue(gPRow, "addr2Jumin",	rv["engAddr"]);
	}
	if( pGubun == "zip" ) {
		sheet0.SetCellValue(gPRow, "zip",			rv["zip"]);
		sheet0.SetCellValue(gPRow, "addr1",			rv["addr"]);
		sheet0.SetCellValue(gPRow, "addr2",			rv["engAddr"]);
	}
    
    
}


// 우편번호 검색 팝업 
function sheet0_OnPopupClick(Row,Col) {
	try {
		gPRow = Row;
		if(sheet0.ColSaveName(Col) == "zipBonjuk") {
			pGubun = "zipBonjuk";
			openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740","740", function(obj){
				sheet0.SetCellValue(gPRow, "zipBonjuk",		obj["zip"]);
				sheet0.SetCellValue(gPRow, "addr1Bonjuk",	obj["doroFullAddr"]);
				sheet0.SetCellValue(gPRow, "addr2Bonjuk",	"");
			});
		}
		
		if(sheet0.ColSaveName(Col) == "zipJumin") {
			pGubun = "zipJumin";
			openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740","740", function(obj){
				sheet0.SetCellValue(gPRow, "zipJumin",		obj["zip"]);
				sheet0.SetCellValue(gPRow, "addr1Jumin",	obj["doroFullAddr"]);
				sheet0.SetCellValue(gPRow, "addr2Jumin",	"");
				
			});
		}
		
		if(sheet0.ColSaveName(Col) == "zip") {
			pGubun = "zip";
			openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740","740", function(obj){
				sheet0.SetCellValue(gPRow, "zip",			obj["zip"]);
				sheet0.SetCellValue(gPRow, "addr1",			obj["doroFullAddr"]);
				sheet0.SetCellValue(gPRow, "addr2",			"");
				
			});
		}
		
		if(sheet0.ColSaveName(Col) == "acaSchNm") {
			pGubun = "acaSchNm";
			if(sheet0.GetCellValue(Row,"acaCd") == "") {
				alert("학력구분을 선택하여 주십시오.");
				return;
			}
			
			var gubun = "";
			if(sheet0.GetCellValue(Row,"acaCd") == "A")	gubun = "H20148_0";	//고등학교
			if(sheet0.GetCellValue(Row,"acaCd") == "B")	gubun = "H20149_0";	//전문대학
			if(sheet0.GetCellValue(Row,"acaCd") == "C")	gubun = "H20150_0";	//대학교
			if(sheet0.GetCellValue(Row,"acaCd") == "D")	gubun = "H20150_0";	//대학원
			
			commonCodeSearchPopup(gubun);
			
		}
		
	} catch (ex) {
		alert("OnPopupClick Event Error : " + ex);
	}
}


//sheet0 Action
function doAction0(sAction) {
	switch (sAction) {
	case "Search": 	 	sheet0.DoSearch( "${ctx}/GetDataList.do?cmd=getApplicantBasisList", $("#srchFrm").serialize() ); break;
	case "Save": 		
		if($("#searchRecruitTitle").val() != "" && $("#searchRecruitTitle").val() != null && $("#searchApplKey").val() != "" && $("#searchApplKey").val() != null){
			
			// 중복체크
			//if (!dupChk(sheet0, "applKey", false, true)) {break;}
			IBS_SaveName(document.srchFrm,sheet0);
			sheet0.DoSave( "${ctx}/RecBasicInfoReg.do?cmd=saveApplicantBasis", $("#srchFrm").serialize());
		}else{
			alert("채용공고 선택후 저장이 가능 합니다.");
		}
		break;
	case "Insert":		
		if("${ssnEnterCd}" =="DGBC") {
			if(sheet0.RowCount() > 0 ){
				alert("기본사항은 1건만 입력이 가능합니다."); return;
			}
		}
		var lRow = sheet0.DataInsert(0);
		//sheet0.SelectCell(sheet0.DataInsert(0), "applKey");
		sheet0.SetCellValue(lRow,"applKey",$("#searchApplKey").val());
		sheet0.SetCellValue(lRow,"name",searchName);

		if("${ssnEnterCd}" =="DGBC") {
			var insertInfo = ajaxCall("${ctx}/RecBasicInfoReg.do?cmd=getRecBasicInfoRegPopList&receiveNo="+$("#searchReceiveNo").val(), $("#srchFrm").serialize(), false);

			if (insertInfo.DATA != null) {
				// 기본정보 입력시 중복 데이터 조회
				sheet0.SetCellValue(lRow,"cname",insertInfo.DATA[0].cname);
				sheet0.SetCellValue(lRow,"ename",insertInfo.DATA[0].ename1);
				sheet0.SetCellValue(lRow,"sexType",insertInfo.DATA[0].sexType);
				sheet0.SetCellValue(lRow,"mobileNo",insertInfo.DATA[0].mobileNo);
				sheet0.SetCellValue(lRow,"mailAddr",insertInfo.DATA[0].mailAddr);
				sheet0.SetCellValue(lRow,"resNo",insertInfo.DATA[0].resNo);
				sheet0.SetCellValue(lRow,"birYmd",insertInfo.DATA[0].birYmd);
				sheet0.SetCellValue(lRow,"lunType",insertInfo.DATA[0].lunType);
				sheet0.SetCellValue(lRow,"wedYn",insertInfo.DATA[0].wedYn);
				sheet0.SetCellValue(lRow,"wedYmd",insertInfo.DATA[0].wedYmd);
				sheet0.SetCellValue(lRow,"foreignYn",insertInfo.DATA[0].foreignYn);
				sheet0.SetCellValue(lRow,"bloodCd",insertInfo.DATA[0].bloodCd);
				sheet0.SetCellValue(lRow,"relCd",insertInfo.DATA[0].relCd);
				sheet0.SetCellValue(lRow,"nationalCd",insertInfo.DATA[0].nationalCd);
				sheet0.SetCellValue(lRow,"hobby",insertInfo.DATA[0].hobby);
				sheet0.SetCellValue(lRow,"specialityNote",insertInfo.DATA[0].specialityNote);
			}
		}


		break;
	case "Copy":		sheet0.DataCopy(); break;
	case "Clear":		sheet0.RemoveAll(); break;
	case "Down2Excel":	sheet0.Down2Excel(); break;
	case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet0.LoadExcel(params); break;
	}
}

// 조회 후 에러 메시지
function sheet0_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { 
		if (Msg != "") { 
			alert(Msg); 
		} 
		sheetResize(); 
	} catch (ex) { 
		alert("OnSearchEnd Event Error : " + ex); 
	}
}

// 셀 클릭시 발생
function sheet0_OnChange(Row, Col, Value) {
	try{
		if( sheet0.ColSaveName(Col) == "acaCd"  ) {
			var code = sheet0.GetCellValue( Row,Col);

			sheet0.SetCellValue(Row,"acaSchCd","");
			sheet0.SetCellValue(Row,"acaSchNm","");

			if(code == "") {
				sheet0.SetColEditable("acaSchNm",false);
			} else if(code == "04" || code == "05" || code == "06") {
				var info = {Type: "Popup", Align: "Left", Edit:1};
				sheet0.InitCellProperty(Row, "acaSchNm", info);
				sheet0.SelectCell(Row,"acaSchNm");
			} else {
				var info = {Type: "Text", Align: "Left", Edit:1};
				sheet0.InitCellProperty(Row, "acaSchNm", info);
				sheet0.SelectCell(Row,"acaSchNm");
			}
	    }
	}catch(ex){
		alert("OnChange Event Error : " + ex);
	}
}



// 저장 후 메시지
function sheet0_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{
		if(Msg != ""){ 
			alert(Msg); 
		}
		doAction0("Search");
	}catch(ex){ 
		alert("OnSaveEnd Event Error " + ex); 
	}
}

// 셀에서 키보드가 눌렀을때 발생하는 이벤트
function sheet0_OnKeyDown(Row, Col, KeyCode, Shift) {
	try {
		// Insert KEY
		if (Shift == 1 && KeyCode == 45) {
			doAction1("Insert");
		}
		//Delete KEY
		if (Shift == 1 && KeyCode == 46 && sheet0.GetCellValue(Row, "sStatus") == "I") {
			sheet0.SetCellValue(Row, "sStatus", "D");
		}
	} catch (ex) {
		alert("OnKeyDown Event Error : " + ex);
	}
}

//Sheet1 Action
function doAction1(sAction) {
	switch (sAction) {
	case "Search": 	 	sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getApplicantFamilyList", $("#srchFrm").serialize() ); break;
	case "Save": 		
		if("${ssnEnterCd}" =="DGBC") {
			if(sheet0.RowCount("R") <= 0 ){
				alert("기본사항을 먼저 입력후 저장하여 주시기 바랍니다."); return;
			}
		}
						IBS_SaveName(document.srchFrm,sheet1);
						sheet1.DoSave( "${ctx}/RecBasicInfoReg.do?cmd=saveApplicantFamily", $("#srchFrm").serialize()); break;
	case "Insert":		
		if("${ssnEnterCd}" =="DGBC") {
			if(sheet0.RowCount("R") <= 0 ){
				alert("기본사항을 먼저 입력후 저장하여 주시기 바랍니다."); return;
			}
		}
						var lRow = sheet1.DataInsert(0);
						sheet1.SetCellValue(lRow,"applKey",$("#searchApplKey").val());
						sheet1.SetCellValue(lRow,"name",searchName);
						break;
	case "Copy":		sheet1.DataCopy(); break;
	case "Clear":		sheet1.RemoveAll(); break;
	case "Down2Excel":	sheet1.Down2Excel(); break;
	case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
	}
}
//셀 클릭시 발생
function sheet1_OnChange(Row, Col, Value) {
	try{
		//codeChk(Row);
	}catch(ex){
		alert("OnChange Event Error : " + ex);
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } 
		sheetResize(); 
		//codeChk(-1);
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{
		if(Msg != ""){ 
			alert(Msg); 
		} 
		doAction1("Search");
	}catch(ex){ 
		alert("OnSaveEnd Event Error " + ex); 
	}
}

// 팝업 클릭시 발생
function sheet1_OnPopupClick(Row,Col) {
	try {
		gPRow = Row;
		if(sheet1.ColSaveName(Col) == "famCdNm") {
			commonCodeSearchPopup("H20120");
		}
		if(sheet1.ColSaveName(Col) == "famAcaNm") {
			commonCodeSearchPopup("H20135");
		}
	} catch (ex) {
		alert("OnPopupClick Event Error : " + ex);
	}
}

// 셀에서 키보드가 눌렀을때 발생하는 이벤트
function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
	try {
		// Insert KEY
		if (Shift == 1 && KeyCode == 45) {
			doAction1("Insert");
		}
		//Delete KEY
		if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
			sheet1.SetCellValue(Row, "sStatus", "D");
		}
		
	} catch (ex) {
		alert("OnKeyDown Event Error : " + ex);
	}
}

//sheet2 Action
function doAction2(sAction) {
	switch (sAction) {
	case "Search": 	 	
		var param = {"Param":"cmd=getRecBasicInfoRegDetailPopSchoolList&defaultRow=100&"+$("#srchFrm").serialize()};
		sheet2.DoSearchPaging( "${ctx}/GetDataList.do", param ); break;
	break;
	case "Save": 		
		if("${ssnEnterCd}" =="DGBC") {
			if(sheet0.RowCount("R") <= 0 ){
				alert("기본사항을 먼저 입력후 저장하여 주시기 바랍니다."); return;
			}
		}
		  // 중복체크
		if (!dupChk(sheet2, "applKey|acaSYm", false, true)) {break;}
		IBS_SaveName(document.srchFrm,sheet2);
		sheet2.DoSave( "${ctx}/RecBasicInfoReg.do?cmd=saveApplicantScholarship", $("#srchFrm").serialize()); break;
	case "Insert":		
		if("${ssnEnterCd}" =="DGBC") {
			if(sheet0.RowCount("R") <= 0 ){
				alert("기본사항을 먼저 입력후 저장하여 주시기 바랍니다."); return;
			}
		}
						var lRow = sheet2.DataInsert(0);
						sheet2.SetCellValue(lRow,"applKey",$("#searchApplKey").val());
						sheet2.SetCellValue(lRow,"name",searchName);
						break;
	case "Copy":		sheet2.DataCopy(); break;
	case "Clear":		sheet2.RemoveAll(); break;
	case "Down2Excel":	sheet2.Down2Excel(); break;
	case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet2.LoadExcel(params); break;
	}
}

// 조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try{ 
		if(Msg != ""){ 
			alert(Msg); 
		} 
		
		sheetResize();
		
	}catch(ex){ 
		alert("OnSearchEnd Event Error : " + ex); 
	}
}

// 저장 후 메시지
function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{ 
		if(Msg != ""){ 
			alert(Msg); 
		}
		doAction2("Search");
	}catch(ex){ 
		alert("OnSaveEnd Event Error " + ex); 
	}
}

// 셀에서 키보드가 눌렀을때 발생하는 이벤트
function sheet2_OnKeyDown(Row, Col, KeyCode, Shift) {
	try {
		if(sheet2.GetCellEditable(Row,Col) == true) {
			if(sheet2.ColSaveName(Col) == "acaSchNm" && KeyCode == 46) {
				sheet2.SetCellValue(Row,"acaSchCd","");
			}
		}
	} catch (ex) {
		alert("OnKeyDown Event Error : " + ex);
	}
}

// 팝업 클릭시 발생
function sheet2_OnPopupClick(Row,Col) {
	try {
		gPRow = Row;
		if(sheet2.ColSaveName(Col) == "acaSchNm") {
			if(sheet2.GetCellValue(Row,"acaCd") == "") {
				alert("학력구분을 선택하여 주십시오.");
				return;
			}
			var gubun = "";
			if(sheet2.GetCellValue(Row,"acaCd") == "A")	gubun = "H20148";	//고등학교
			if(sheet2.GetCellValue(Row,"acaCd") == "B")	gubun = "H20149";	//전문대학
			if(sheet2.GetCellValue(Row,"acaCd") == "C")	gubun = "H20150";	//대학교
			if(sheet2.GetCellValue(Row,"acaCd") == "D")	gubun = "H20150";	//대학원
			
			//var param = [];
			//param["gubun"] = gubun;

			commonCodeSearchPopup(gubun);
			/*
            var rst = openPopup("/HrmSchoolPopup.do?cmd=viewHrmSchoolPopup&authPg=${authPg}", param, "540","620");
            if(rst != null){
            	sheet2.SetCellValue(Row, "acaSchCd", rst["code"]);
            	sheet2.SetCellValue(Row, "acaSchNm", rst["codeNm"]);
            }
            */
		}
	} catch (ex) {
		alert("OnPopupClick Event Error : " + ex);
	}
}

// 셀 클릭시 발생
function sheet2_OnChange(Row, Col, Value) {
	try{
		if( sheet2.ColSaveName(Col) == "acaCd"  ) {
			var code = sheet2.GetCellValue( Row,Col);

			sheet2.SetCellValue(Row,"acaSchCd","");
			sheet2.SetCellValue(Row,"acaSchNm","");

			if(code == "") {
				sheet2.SetColEditable("acaSchNm",false);
			} else if(code == "A" || code == "B" || code == "C" || code == "D")) {
				var info = {Type: "Popup", Align: "Left", Edit:1};
				sheet2.InitCellProperty(Row, "acaSchNm", info);
				sheet2.SelectCell(Row,"acaSchNm");
			} else {
				var info = {Type: "Text", Align: "Left", Edit:1};
				sheet2.InitCellProperty(Row, "acaSchNm", info);
				sheet2.SelectCell(Row,"acaSchNm");
			}
	    }
	}catch(ex){
		alert("OnChange Event Error : " + ex);
	}
}

//sheet3 Action
function doAction3(sAction) {
	switch (sAction) {
	case "Search": 	 	sheet3.DoSearch( "${ctx}/GetDataList.do?cmd=getRecBasicInfoRegDetailPopLicenseList", $("#srchFrm").serialize() ); break;
	case "Save": 		
		if("${ssnEnterCd}" =="DGBC") {
			if(sheet0.RowCount("R") <= 0 ){
				alert("기본사항을 먼저 입력후 저장하여 주시기 바랍니다."); return;
			}
		}
						IBS_SaveName(document.srchFrm,sheet3);
						sheet3.DoSave( "${ctx}/RecBasicInfoReg.do?cmd=saveApplicantLicense", $("#srchFrm").serialize()); break;
	case "Insert":		
		if("${ssnEnterCd}" =="DGBC") {
			if(sheet0.RowCount("R") <= 0 ){
				alert("기본사항을 먼저 입력후 저장하여 주시기 바랍니다."); return;
			}
		}
						var lRow = sheet3.DataInsert(0);
						sheet3.SetCellValue(lRow,"applKey",$("#searchApplKey").val());
						sheet3.SetCellValue(lRow,"name",searchName);
						break;
	case "Copy":		sheet3.DataCopy(); break;
	case "Clear":		sheet3.RemoveAll(); break;
	case "Down2Excel":	sheet3.Down2Excel(); break;
	case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet3.LoadExcel(params); break;
	}
}


// 조회 후 에러 메시지
function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { 
		if (Msg != "") { 
			alert(Msg); 
		}

		for(var i = 0; i < sheet3.RowCount(); i++) {
			var code = sheet3.GetCellValue(i+1,"licenseGubun");
			sheet3.SetCellValue(i+1,"sStatus","R");
			
		}
		
		sheetResize();
	} catch (ex) { 
		alert("OnSearchEnd Event Error : " + ex); 
	}
}

// 저장 후 메시지
function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { 
		if (Msg != "") {
			alert(Msg); 
		}	
		doAction3("Search");
	} catch (ex) { 
		alert("OnSaveEnd Event Error " + ex); 
	}
}	

// 셀에서 키보드가 눌렀을때 발생하는 이벤트
function sheet3_OnKeyDown(Row, Col, KeyCode, Shift) {
	try {
		if(sheet3.GetCellEditable(Row,Col) == true) {
			if(sheet3.ColSaveName(Col) == "licenseNm" && KeyCode == 46) {
				sheet3.SetCellValue(Row,"licenseCd","");
			}
		}
	} catch (ex) {
		alert("OnKeyDown Event Error : " + ex);
	}
}
function sheet3_OnPopupClick(Row,Col) {
	try {
		gPRow = Row;
		if(sheet3.ColSaveName(Col) == "licenseNm") {
            commonCodeSearchPopup("H20160");
		}
	} catch (ex) {
		alert("OnPopupClick Event Error : " + ex);
	}
}	

//sheet4 Action
function doAction4(sAction) {
	switch (sAction) {
	case "Search": 	 	sheet4.DoSearch( "${ctx}/GetDataList.do?cmd=getRecBasicInfoRegDetailPopCareerList", $("#srchFrm").serialize() ); break;
	case "Save": 		
		if("${ssnEnterCd}" =="DGBC") {
			if(sheet0.RowCount("R") <= 0 ){
				alert("기본사항을 먼저 입력후 저장하여 주시기 바랍니다."); return;
			}
		}
						IBS_SaveName(document.srchFrm,sheet4);
						sheet4.DoSave( "${ctx}/RecBasicInfoReg.do?cmd=saveApplicantOutSideHistory", $("#srchFrm").serialize()); break;
	case "Insert":		
		if("${ssnEnterCd}" =="DGBC") {
			if(sheet0.RowCount("R") <= 0 ){
				alert("기본사항을 먼저 입력후 저장하여 주시기 바랍니다."); return;
			}
		}
						var lRow = sheet4.DataInsert(0);
						sheet4.SetCellValue(lRow,"applKey",$("#searchApplKey").val());
						sheet4.SetCellValue(lRow,"name",searchName);
						break;
	case "Copy":		sheet4.DataCopy(); break;
	case "Clear":		sheet4.RemoveAll(); break;
	case "Down2Excel":	sheet4.Down2Excel(); break;
	case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet4.LoadExcel(params); break;
	}
}


// 조회 후 에러 메시지
function sheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet4_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{
		if(Msg != ""){ 
			alert(Msg); 
		}
		doAction4("Search");
	}catch(ex){ 
		alert("OnSaveEnd Event Error " + ex); 
	}
}

// 셀에서 키보드가 눌렀을때 발생하는 이벤트
function sheet4_OnKeyDown(Row, Col, KeyCode, Shift) {
	try {
		// Insert KEY
		if (Shift == 1 && KeyCode == 45) {
			doAction1("Insert");
		}
		//Delete KEY
		if (Shift == 1 && KeyCode == 46 && sheet4.GetCellValue(Row, "sStatus") == "I") {
			sheet4.SetCellValue(Row, "sStatus", "D");
		}
	} catch (ex) {
		alert("OnKeyDown Event Error : " + ex);
	}
}

//sheet5 Action
function doAction5(sAction) {
	switch (sAction) {
	case "Search":
		sheet5.DoSearch( "${ctx}/GetDataList.do?cmd=getRecBasicInfoRegDetailPopLanList", $("#srchFrm").serialize() ); break;
	case "Save":
		if("${ssnEnterCd}" =="DGBC") {
			if(sheet0.RowCount("R") <= 0 ){
				alert("기본사항을 먼저 입력후 저장하여 주시기 바랍니다."); return;
			}
		}
						IBS_SaveName(document.srchFrm,sheet5);
						sheet5.DoSave( "${ctx}/RecBasicInfoReg.do?cmd=saveApplicantForeignLanguage2", $("#srchFrm").serialize()); break;
	case "Insert":
		if("${ssnEnterCd}" =="DGBC") {
			if(sheet0.RowCount("R") <= 0 ){
				alert("기본사항을 먼저 입력후 저장하여 주시기 바랍니다."); return;
			}
		}
						var lRow = sheet5.DataInsert(0);
						sheet5.SetCellValue(lRow,"applKey",$("#searchApplKey").val());
						sheet5.SetCellValue(lRow,"name",searchName);
						break;		
	case "Copy":		sheet5.DataCopy(); break;
	case "Clear":		sheet5.RemoveAll(); break;
	case "Down2Excel":	sheet5.Down2Excel(); break;
	case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet5.LoadExcel(params); break;
	}
}

//조회 후 에러 메시지
function sheet5_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet5_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{
		if(Msg != ""){ 
			alert(Msg); 
		}
		doAction5("Search");
	}catch(ex){ 
		alert("OnSaveEnd Event Error " + ex); 
	}
}

// 팝업 클릭시 발생
function sheet5_OnPopupClick(Row,Col) {
	try {
		gPRow = Row;
		if(sheet5.ColSaveName(Col) == "foreignNm") {
			commonCodeSearchPopup("H20300");
		}
	} catch (ex) {
		alert("OnPopupClick Event Error : " + ex);
	}
}

// 셀에서 키보드가 눌렀을때 발생하는 이벤트
function sheet5_OnKeyDown(Row, Col, KeyCode, Shift) {
	try {
		// Insert KEY
		if (Shift == 1 && KeyCode == 45) {
			doAction1("Insert");
		}
		//Delete KEY
		if (Shift == 1 && KeyCode == 46 && sheet5.GetCellValue(Row, "sStatus") == "I") {
			sheet5.SetCellValue(Row, "sStatus", "D");
		}
	} catch (ex) {
		alert("OnKeyDown Event Error : " + ex);
	}
}

</script>
</head>
<body class="bodywrap" onload="startView();">

<div class="wrapper">
	<div class="popup_title" >
		<ul>
			<li>채용 세부정보</li>
			<li class="close"></li>
		</ul>
	</div>
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchRecruitTitle" name="searchRecruitTitle"/>
		<input type="hidden" id="searchApplKey" name="searchApplKey"/>
		<input type="hidden" id="searchReceiveNo" name="searchReceiveNo"/>
	</form>
	<div class="popup_main">
		<div id="tabs" class="hide" style="width:100%">
			<ul class="outer tab_bottom">
				<li onclick="clickTabs('0');"><a href="#tabs-0">기본</a></li>
				<li onclick="clickTabs('1');"><a href="#tabs-1">가족</a></li>
				<li onclick="clickTabs('2');"><a href="#tabs-2">학력</a></li>
				<li onclick="clickTabs('3');"><a href="#tabs-3">자격</a></li>
				<li onclick="clickTabs('4');"><a href="#tabs-4">경력</a></li>
				<li onclick="clickTabs('5');"><a href="#tabs-5">외국어</a></li>
			</ul>
			<div id="tabs-0">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">기본사항</li>
						<li class="btn">
							<a href="javascript:doAction0('Search')" 	class="basic authR">조회</a>
							
							<a href="javascript:doAction0('Insert')" class="basic authA">입력</a>
							<%-- 
							<a href="javascript:doAction0('Copy')" 	class="basic authA">복사</a>
							--%>
							<a href="javascript:doAction0('Save')" 	class="basic authA">저장</a>
							<a href="javascript:doAction0('Down2Excel')" 	class="basic authR">다운로드</a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet0", "100%", "100%"); </script>
			</div>
						
			<div id="tabs-1">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">가족</li>
						<li class="btn">
							<a href="javascript:doAction1('Search')" 	class="basic authR">조회</a>
							<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
							<!--  
							<a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a>
							-->
							<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
							<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
			</div>

			<div id="tabs-2">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">학력</li>
						<li class="btn">
							<a href="javascript:doAction2('Search')" 	class="basic authR">조회</a>
							<a href="javascript:doAction2('Insert')" class="basic authA">입력</a>
							<!--  
							<a href="javascript:doAction2('Copy')" 	class="basic authA">복사</a>
							-->
							<a href="javascript:doAction2('Save')" 	class="basic authA">저장</a>
							<a href="javascript:doAction2('Down2Excel')" 	class="basic authR">다운로드</a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>
			</div>

			<div id="tabs-3">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">자격</li>
						<li class="btn">
							<a href="javascript:doAction3('Search')" 	class="basic authR">조회</a>
							<a href="javascript:doAction3('Insert')" class="basic authA">입력</a>
							<!--  
							<a href="javascript:doAction3('Copy')" 	class="basic authA">복사</a>
							-->
							<a href="javascript:doAction3('Save')" 	class="basic authA">저장</a>
							<a href="javascript:doAction3('Down2Excel')" 	class="basic authR">다운로드</a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet3", "100%", "100%"); </script>
			</div>

			<div id="tabs-4">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">경력</li>
						<li class="btn">
							<a href="javascript:doAction4('Search')" 	class="basic authR">조회</a>
							<a href="javascript:doAction4('Insert')" class="basic authA">입력</a>
							<!--  
							<a href="javascript:doAction4('Copy')" 	class="basic authA">복사</a>
							-->
							<a href="javascript:doAction4('Save')" 	class="basic authA">저장</a>
							<a href="javascript:doAction4('Down2Excel')" 	class="basic authR">다운로드</a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet4", "100%", "100%"); </script>
			</div>

			<div id="tabs-5">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">외국어</li>
						<li class="btn">
							<a href="javascript:doAction5('Search')" 	class="basic authR">조회</a>
							<a href="javascript:doAction5('Insert')" class="basic authA">입력</a>
							<!--  
							<a href="javascript:doAction5('Copy')" 	class="basic authA">복사</a>
							-->
							<a href="javascript:doAction5('Save')" 	class="basic authA">저장</a>
							<a href="javascript:doAction5('Down2Excel')" 	class="basic authR">다운로드</a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet5", "100%", "100%"); </script>
			</div>
		</div>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:setValue();" class="pink large authA">확인</a>
					<a href="javascript:p.self.close();" class="gray large authR">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>