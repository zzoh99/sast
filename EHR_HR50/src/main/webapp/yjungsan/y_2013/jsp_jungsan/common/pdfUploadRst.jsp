<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.xml.parsers.DocumentBuilder"%>
<%@ page import="javax.xml.parsers.DocumentBuilderFactory"%>
<%@ page import="PDFExport.ezPDFExportFile"%>
<%@ page import="etiming.astdts.apl3161.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.jdom2.Document"%>
<%@ page import="org.jdom2.Element"%>
<%@ page import="org.jdom2.input.SAXBuilder"%>
<%@ page import="org.w3c.dom.Node"%>
<%@ page import="org.w3c.dom.NodeList"%>
<%@ page import="org.xml.sax.InputSource"%>
<%@ page import="com.hr.common.logger.Log" %>
<%@ page import="yjungsan.exception.UserException"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.sql.Connection"%>
<%@ include file="../common/include/session.jsp"%>

<%!
    //초기화된 데이터 맵
    public Map getDefaultDataMap(String ssnEnterCd, String ssnSabun, String workYy, String adjustType, String sabun, String docType, String docSeq, String formCd, String resId, String manName) {
        Map mp = new HashMap();
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("workYy", workYy);
        mp.put("adjustType", adjustType);
        mp.put("sabun", sabun);
        mp.put("docType", docType);
        mp.put("docSeq", docSeq);
        mp.put("formCd", formCd);
        
        for(int i = 1; i <= 30; i++) {
            mp.put("A"+i,"");
        }

        mp.put("A1", resId);
        mp.put("A2", manName);
        
        return mp;
    }
%>

<%
    //Logger log = Logger.getLogger(this.getClass());

    Log.Debug("request.getContentType() === "+request.getContentType());
    Log.Debug("request.getCharacterEncoding() === "+request.getCharacterEncoding());

    //로그인 정보 Session취득
    String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
    String ssnSabun = (String)session.getAttribute("ssnSabun");
    
    //파라메터 초기화.
    String paramYear = "";            //연말정산 년도
    String paramSabun = "";           //사번
    String paramPwd = "";             //pdf 패스워드
    String paramAdjustType = "";      //연말정산 타입(1:연말정산, 2:퇴직정산)
    
    String procMessage = "";          //프로시저 실행후 메시지.
  
try {
    Log.Debug("=============================pdf 파일 업로드 시작=============================");
    Log.Debug("ssnEnterCd ===== "+ssnEnterCd);
    Log.Debug("ssnSabun ===== "+ssnSabun);
    Log.Debug("paramYear ===== "+paramYear);
    Log.Debug("paramSabun ===== "+paramSabun);
    Log.Debug("paramPwd ===== "+paramPwd);
    Log.Debug("paramAdjustType ===== "+paramAdjustType);
    
    /* 업로드 파일 정의 부분(해당 시스템에서 사용하는 파일 업로드 패키지에 따라 수정 필요) */
    DiskFileUpload fileUpload = new DiskFileUpload();
    
    fileUpload.setHeaderEncoding(sysEnc);
    
    /* 업로드 컨텐츠 목록 추출 */
    List fileItemList = fileUpload.parseRequest(request);
    
    /* 업로드 컨텐츠 종류에 따라 반복 처리 */
    int v_fileCnt = fileItemList.size();
    
    //폼필드 부분만 먼저 가져온다.
    for(int i = 0 ; i < v_fileCnt ; i++){
        FileItem fileItem = (FileItem) fileItemList.get(i);
        /* 문서 비밀번호 가져오기(비밀번호 없는 문서일 경우 생략 가능. 이 때 p_pwd=null) */
        // 방식1.사용자 입력 방식인 경우(폼필드 입력값 추출)
        if ( fileItem.isFormField() ) {
            if ( "paramPwd".equals(fileItem.getFieldName()) ) {
                paramPwd = fileItem.getString();
            } else if("paramSabun".equals(fileItem.getFieldName()) ) {
                paramSabun = fileItem.getString();
            } else if("paramYear".equals(fileItem.getFieldName()) ) {
                paramYear = fileItem.getString();
            } else if("paramAdjustType".equals(fileItem.getFieldName()) ) {
                paramAdjustType = fileItem.getString();
            }
        }
    }
    
    //파일 부분 가져와서 체크.
    for(int i = 0 ; i < v_fileCnt ; i++){
        FileItem fileItem = (FileItem) fileItemList.get(i);
        
        //폼필드라면 이미 그전에 변수에 할당했다.
        if ( fileItem.isFormField() ) {
            continue;
        }
        
        // path 제외한 파일명만 취득
        String[] filePath = fileItem.getName().split("\\\\");
        String fileName = filePath[filePath.length -1]; //파일명(ex:abcd.pdf)
        
        Log.Debug("fileName ===== "+fileName);
        // PDF파일이 아닌 경우 skip
        if (fileName == null || !fileName.toUpperCase().endsWith(".PDF") ) {
            throw new UserException("PDF 파일이 아닙니다.");
        }
        
        // 파일내용을 읽음
        byte[] pdfBytes = fileItem.get();
        
        String pdfBytesEnc = String.valueOf(new InputStreamReader(fileItem.getInputStream()).getEncoding()).toLowerCase();
        Log.Debug("pdf 파일인코딩 ==== "+pdfBytesEnc);

        //DB에 넣을 데이터가 들어갈 변수 초기화.
        List dataList = new ArrayList();
        Map dataMap   = new HashMap();
        
        //파일 저장 데이터가 들어갈 변수 초기화.
        Map fileMap   = new HashMap();
        
        //xml 파싱에 필요한 변수.
        List childList  = null;
        List childList2 = null;
        List childList3 = null;

        Element ele  = null;
        Element ele2 = null;
        Element ele3 = null;
        
        String docName = "";
        String docValue = "";
        String docType = "";
        String docSeq = "";
        String docAttYear = "";
        
        /* [Step1] 전자문서 위변조 검증 */
        try {
            /* 진본성 검증 초기화 */
            TSSPdfTSTValidator.init(cacertPath, CertVerifyConst.NONE, null );
            // "/cacerts"는 API와 함께 배포되는 서버인증서(RootCA.cer,CA131000001.cer)가 저장된 위치로 각 시스템에 맞게 수정 가능
            /* 전자문서 검증 */
            
            int result = TSSPdfTSTValidator.validatorByte(pdfBytes,paramPwd,paramPwd);
            if( result == 0 ){
                //out.println("<!-- 검증 완료(진본) -->");
                //continue;
            } else {
                String errMessage = "";
                switch(result){
                    case 101: errMessage = "진본성 검증 초기화에 문제가 있습니다."; break;
                    case 201: errMessage = "PDF문서가 아닙니다."; break;
                    case 202: errMessage = "타임스탬프가 발급되지 않은 문서 입니다."; break;
                    case 203: errMessage = "변조된 문서 입니다."; break;
                    case 204: errMessage = "비밀번호가 틀립니다."; break;
                    case 205: errMessage = "손상된 문서입니다."; break;
                    case 301: errMessage = "토큰정보 추출에 문제가 있습니다."; break;
                    case 302: errMessage = "미지원 토큰정보 입니다."; break;
                    case 401: errMessage = "CRL 목록의 시간이 지났거나 파기 되었습니다."; break;
                    default : errMessage = "알수없는 에러입니다."; break;
                }
                
                throw new UserException(errMessage);
            }
        // 기타 검증결과는 Exception을 발생 시킴
        } catch (UserException ue) {
            throw new UserException(ue.getMessage());
        } catch (Exception ex) {
            throw new Exception(ex);
        }

        /* [Step2] XML(or SAM) 데이터 추출 */
        try {
            
            ezPDFExportFile pdf = new ezPDFExportFile();
            
            
            // 데이터 추출
            byte[] buf = pdf.NTS_GetFileBufEx(pdfBytes , paramPwd, "XML", ("utf8".equals(pdfBytesEnc)?false:true));
            int v_ret = pdf.NTS_GetLastError();

            Document document = null; // 문서
            
            //문서 정상
            if ( v_ret == 1 ) {
                String strXml = new String( buf , pdfBytesEnc);
                SAXBuilder saxBuilder = new SAXBuilder();
                  document = saxBuilder.build(new ByteArrayInputStream(strXml.getBytes()));
            
                // 정상적으로 추출된 데이터 활용하는 로직 구현 부분
                //str = strXml;
                Log.Debug(strXml);
                //out.println(strXml); // 예제에서는 화면에 출력
                
                  Element element = document.getRootElement();
                  List childElementList = element.getChildren();
                  
                docName = "";
                docValue = "";
                docType = "";
                docSeq = "";
                docAttYear = "";
                  
                  String formCd = "";
                  String manResId = "";
                  String manName = "";
                  
                  String dataEtcName = "";
                  String dataEtcValue = "";
                  
                for(int childIndex = 0; childIndex < childElementList.size(); childIndex++ ) {
                    String tagName = ((Element)childElementList.get(childIndex)).getName();
                    
                      childList  = null;
                      childList2 = null;
                      childList3 = null;
                      ele        = null;
                      ele2       = null;
                      ele3       = null;
                      
                        formCd = "";
                        manResId = "";
                        manName = "";
                        dataEtcName = "";
                        dataEtcValue = "";

                      if("doc".equals(tagName)) {
                          //문서정의 구간.
                            ele = (Element)childElementList.get(childIndex);
                            childList = ele.getChildren();

                            for(int docIndex = 0; docIndex < childList.size(); docIndex++) {
                            docName = ((Element)childList.get(docIndex)).getName();
                            docValue = ((Element)childList.get(docIndex)).getValue();
                            
                            if("doc_type".equals(docName)) {
                                docType = docValue;
                            } else if("seq".equals(docName)) {
                                docSeq = docValue;
                            } else if("att_year".equals(docName)) {
                                docAttYear = docValue;
                                
                                if(!docAttYear.equals(paramYear)) {
                                    throw new UserException("파일의 연말정산 연도가 다릅니다.");
                                }
                            }
                        }
                            
                            if(!"A".equals(docType)) {
                            throw new UserException("PDF 파일이 연간요약본이 아닙니다.\\n연간요약본으로 업로드하여 주십시오.");
                            }
                    } else if("form".equals(tagName)) {
                        //서식별 반복구간.
                        //서식코드
                        formCd = ((Element)childElementList.get(childIndex)).getAttributeValue("form_cd");
                          
                            ele = (Element)childElementList.get(childIndex);
                            childList = ele.getChildren();
                            
                            for(int manIndex = 0; manIndex < childList.size(); manIndex++ ) {
                                manResId = ((Element)childList.get(manIndex)).getAttributeValue("resid"); //주민등록번호
                                manName = ((Element)childList.get(manIndex)).getAttributeValue("name"); //성명
                              
                              ele2 = (Element)childList.get(manIndex);
                              childList2 = ele2.getChildren();
                              
                                if("A102Y".equals(formCd)) {
                                      //보험료(보장성,장애인보장성)
                                    
                                    for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                        dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);
                                        
                                        dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                        dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                        dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //상호
                                        dataMap.put("A6",((Element)childList2.get(dataIndex)).getAttributeValue("acc_no")); //증권번호
                                        
                                      ele3 = (Element)childList2.get(dataIndex);
                                      childList3 = ele3.getChildren();
                                      
                                      for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                          dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                          dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                          
                                          if("goods_nm".equals(dataEtcName)) {
                                                dataMap.put("A7",dataEtcValue); //보험종류
                                          } else if("insu1_resid".equals(dataEtcName)) {
                                                dataMap.put("A8",dataEtcValue); //주민등록번호_주피보험자
                                          } else if("insu1_nm".equals(dataEtcName)) {
                                                dataMap.put("A9",dataEtcValue); //성명_주피보험자
                                          } else if("insu2_resid1".equals(dataEtcName)) {
                                                dataMap.put("A10",dataEtcValue); //주민등록번호_종피보험자_1
                                          } else if("insu2_nm1".equals(dataEtcName)) {
                                                dataMap.put("A11",dataEtcValue); //성명_종피보험자_1
                                          } else if("insu2_resid2".equals(dataEtcName)) {
                                                dataMap.put("A12",dataEtcValue); //주민등록번호_종피보험자_2
                                          } else if("insu2_nm2".equals(dataEtcName)) {
                                                dataMap.put("A13",dataEtcValue); //성명_종피보험자_2
                                          } else if("insu2_resid3".equals(dataEtcName)) {
                                                dataMap.put("A14",dataEtcValue); //주민등록번호_종피보험자_3
                                          } else if("insu2_nm3".equals(dataEtcName)) {
                                                dataMap.put("A15",dataEtcValue); //성명_종피보험자_3
                                          } else if("sum".equals(dataEtcName)) {
                                                dataMap.put("A16",dataEtcValue); //납입금액계
                                          }
                                      }
                                      
                                        dataList.add(dataMap);
                                    }
                                } else if("B101Y".equals(formCd)) {
                                    //의료비
                                      
                                      for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                        dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                        dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                          dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                          dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //상호
                                          
                                        ele3 = (Element)childList2.get(dataIndex);
                                        childList3 = ele3.getChildren();
                                        
                                        for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                            dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                            dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                            
                                            if("sum".equals(dataEtcName)) {
                                                dataMap.put("A6",dataEtcValue); //납입금액계
                                            }
                                        }
                                        
                                        dataList.add(dataMap);
                                      }
                                } else if("C101Y".equals(formCd)) {
                                      //교육비(유초중고,대학,기타)
                                    
                                      for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                        dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                        dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                          dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                          dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //학교명
                                          dataMap.put("A6",((Element)childList2.get(dataIndex)).getAttributeValue("edu_tp")); //교육비종류
                                          
                                        ele3 = (Element)childList2.get(dataIndex);
                                        childList3 = ele3.getChildren();
                                        
                                        for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                            dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                            dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                            
                                            if("sum".equals(dataEtcName)) {
                                                dataMap.put("A7",dataEtcValue); // 납입금액계
                                            }                                          
                                        }
                                        
                                        dataList.add(dataMap);
                                      }
                                } else if("C202Y".equals(formCd)) {
                                    //교육비(직업훈련비)
                                      
                                      for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                        dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                        dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                          dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                          dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //교육기관명
                                          
                                        ele3 = (Element)childList2.get(dataIndex);
                                        childList3 = ele3.getChildren();
                                        
                                        for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                            dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                            dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                            
                                            if("course_cd".equals(dataEtcName)) {
                                                dataMap.put("A6",dataEtcValue); //과정코드
                                            } else if("subject_nm".equals(dataEtcName)) {
                                                dataMap.put("A7",dataEtcValue); //과정명
                                            } else if("sum".equals(dataEtcName)) {
                                                dataMap.put("A8",dataEtcValue); //납입금액계
                                            }
                                        }
                                        
                                        dataList.add(dataMap);
                                      }
                                } else if("C301Y".equals(formCd)) {
                                      //교육비(교복구입비)
                                    
                                      for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                        dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                        dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                        dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                        dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //상호
                                          
                                        ele3 = (Element)childList2.get(dataIndex);
                                        childList3 = ele3.getChildren();
                                        
                                        for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                            dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                            dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                            
                                            if("sum".equals(dataEtcName)) {
                                                dataMap.put("A6",dataEtcValue); //납입금액계
                                            }
                                        }
                                        
                                        dataList.add(dataMap);
                                    }
                                } else if("D101Y".equals(formCd)) {
                                    //개인연금저축
                                      
                                      for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                        dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                        dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                          dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                          dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //상호
                                          dataMap.put("A6",((Element)childList2.get(dataIndex)).getAttributeValue("acc_no")); //통장/증권번호
                                          
                                        ele3 = (Element)childList2.get(dataIndex);
                                        childList3 = ele3.getChildren();
                                        
                                        for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                            dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                            dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                            
                                          if("start_dt".equals(dataEtcName)) {
                                                  dataMap.put("A7",dataEtcValue); //계약시작일
                                            } else if("end_dt".equals(dataEtcName)) {
                                                  dataMap.put("A8",dataEtcValue); //계약종료일
                                            } else if("com_cd".equals(dataEtcName)) {
                                                  dataMap.put("A9",dataEtcValue); //금융회사등 코드
                                            } else if("sum".equals(dataEtcName)) {
                                                  dataMap.put("A10",dataEtcValue); //납입금액계
                                            }
                                        }
                                        
                                        dataList.add(dataMap);
                                      }
                                } else if("E102Y".equals(formCd)) {
                                    //연금저축
                                      
                                      for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                        dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                          dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                          dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                          dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //상호
                                          dataMap.put("A6",((Element)childList2.get(dataIndex)).getAttributeValue("acc_no")); //계좌번호
                                          
                                        ele3 = (Element)childList2.get(dataIndex);
                                        childList3 = ele3.getChildren();
                                        
                                        for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                            dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                            dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                            
                                          if("com_cd".equals(dataEtcName)) {
                                                  dataMap.put("A7",dataEtcValue); //금융회사등 코드
                                            } else if("ann_tot_amt".equals(dataEtcName)) {
                                                  dataMap.put("A8",dataEtcValue); //납입액
                                            } else if("tax_year_amt".equals(dataEtcName)) {
                                                  dataMap.put("A9",dataEtcValue); //당해과세연도인출금액
                                            } else if("exce_pay_amt".equals(dataEtcName)) {
                                                  dataMap.put("A10",dataEtcValue); //소득공제한도초과납입액
                                            } else if("ddct_bs_ass_amt".equals(dataEtcName)) {
                                                  dataMap.put("A11",dataEtcValue); //과세제외금액을뺀금액
                                            }
                                        }
                                        
                                        dataList.add(dataMap);
                                      }
                                } else if("F102Y".equals(formCd)) {
                                    //퇴직연금
                                      
                                      for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                        dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                        dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                          dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                          dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //상호
                                          dataMap.put("A6",((Element)childList2.get(dataIndex)).getAttributeValue("acc_no")); //통장,증권번호
                                          
                                        ele3 = (Element)childList2.get(dataIndex);
                                        childList3 = ele3.getChildren();
                                        
                                        for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                            dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                            dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                            
                                          if("com_cd".equals(dataEtcName)) {
                                                  dataMap.put("A7",dataEtcValue); //금융회사등 코드
                                            } else if("pension_cd".equals(dataEtcName)) {
                                                  dataMap.put("A8",dataEtcValue); //연금구분코드
                                            } else if("ann_tot_amt".equals(dataEtcName)) {
                                                  dataMap.put("A9",dataEtcValue); //납입액
                                            } else if("tax_year_amt".equals(dataEtcName)) {
                                                  dataMap.put("A10",dataEtcValue); //당해과세연도인출금액
                                            } else if("exce_pay_amt".equals(dataEtcName)) {
                                                  dataMap.put("A11",dataEtcValue); //소득공제한도초과납입액
                                            } else if("ddct_bs_ass_amt".equals(dataEtcName)) {
                                                  dataMap.put("A12",dataEtcValue); //과세제외금액을뺀금액
                                            }
                                        }
                                        
                                        dataList.add(dataMap);
                                      }
                                } else if("G102Y".equals(formCd)) {
                                    //신용카드
                                      
                                      for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                        dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                        dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                          dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                          dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //상호
                                          dataMap.put("A6",((Element)childList2.get(dataIndex)).getAttributeValue("use_place_cd")); //종류
                                          
                                        ele3 = (Element)childList2.get(dataIndex);
                                        childList3 = ele3.getChildren();
                                        
                                        for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                            dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                            dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                            
                                          if("sum".equals(dataEtcName)) {
                                                  dataMap.put("A7",dataEtcValue); //납입금액계
                                            }
                                        }
                                        
                                        dataList.add(dataMap);
                                      }
                                } else if("G203M".equals(formCd)) {
                                    //현금영수증
                                      
                                      for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                        dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                        dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                          dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("use_place_cd")); //종류
                                          
                                        ele3 = (Element)childList2.get(dataIndex);
                                        childList3 = ele3.getChildren();
                                        
                                        for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                            dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                            dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                            
                                          if("sum".equals(dataEtcName)) {
                                                  dataMap.put("A5",dataEtcValue); //납입금액계
                                            }
                                        }
                                        
                                        dataList.add(dataMap);
                                      }
                                } else if("G302Y".equals(formCd)) {
                                    //직불카드
                                      
                                      for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                        dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                        dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                          dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                          dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //상호
                                          dataMap.put("A6",((Element)childList2.get(dataIndex)).getAttributeValue("use_place_cd")); //종류
                                          
                                        ele3 = (Element)childList2.get(dataIndex);
                                        childList3 = ele3.getChildren();
                                        
                                        for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                            dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                            dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                            
                                          if("sum".equals(dataEtcName)) {
                                                  dataMap.put("A7",dataEtcValue); //공제대상금액합계
                                            }
                                        }
                                        
                                        dataList.add(dataMap);
                                      }
                                } else if("J101Y".equals(formCd)) {
                                    //주택임차차입금 원리금상환액
                                      
                                      for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                        dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                        dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                          dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                          dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //취급기관
                                          dataMap.put("A6",((Element)childList2.get(dataIndex)).getAttributeValue("acc_no")); //계좌번호
                                          
                                        ele3 = (Element)childList2.get(dataIndex);
                                        childList3 = ele3.getChildren();
                                        
                                        for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                            dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                            dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                            
                                          if("goods_nm".equals(dataEtcName)) {
                                                  dataMap.put("A7",dataEtcValue); //상품명
                                          } else if("lend_dt".equals(dataEtcName)) {
                                                    dataMap.put("A8",dataEtcValue); //대출일
                                          } else if("sum".equals(dataEtcName)) {
                                                    dataMap.put("A9",dataEtcValue); //상환액계
                                              }
                                        }
                                        
                                        dataList.add(dataMap);
                                      }
                                } else if("J203Y".equals(formCd)) {
                                    //장기주택저장차입금 이자상환액
                                      
                                      for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                        dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                        dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                          dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                          dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //취급기관
                                          dataMap.put("A6",((Element)childList2.get(dataIndex)).getAttributeValue("acc_no")); //계좌번호
                                          
                                        ele3 = (Element)childList2.get(dataIndex);
                                        childList3 = ele3.getChildren();
                                        
                                        for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                            dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                            dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                            
                                          if("lend_kd".equals(dataEtcName)) {
                                                  dataMap.put("A7",dataEtcValue); //대출종류
                                          } else if("house_take_dt".equals(dataEtcName)) {
                                                    dataMap.put("A8",dataEtcValue); //주택취득일
                                          } else if("mort_setup_dt".equals(dataEtcName)) {
                                                    dataMap.put("A9",dataEtcValue); //저당권설정일
                                          } else if("start_dt".equals(dataEtcName)) {
                                                    dataMap.put("A10",dataEtcValue); //최초차입일
                                          } else if("end_dt".equals(dataEtcName)) {
                                                    dataMap.put("A11",dataEtcValue); //최종상환예정일
                                          } else if("repay_years".equals(dataEtcName)) {
                                                    dataMap.put("A12",dataEtcValue); //상환기간연수
                                          } else if("lend_goods_nm".equals(dataEtcName)) {
                                                    dataMap.put("A13",dataEtcValue); //상품명
                                          } else if("debt".equals(dataEtcName)) {
                                              dataMap.put("A14",dataEtcValue); //차입금
                                          } else if("fixed_rate_debt".equals(dataEtcName)) {
                                                    dataMap.put("A15",dataEtcValue); //고정금리차입금
                                          } else if("not_defer_debt".equals(dataEtcName)) {
                                                    dataMap.put("A16",dataEtcValue); //비거치식상환차입금
                                          } else if("this_year_rede_amt".equals(dataEtcName)) {
                                                    dataMap.put("A17",dataEtcValue); //당해년 원금상환액
                                          } else if("sum".equals(dataEtcName)) {
                                              dataMap.put("A18",((Element)childList3.get(insuIndex)).getAttributeValue("ddct")); //소득공제대상액
                                                    dataMap.put("A19",dataEtcValue); //연간합계액
                                              }
                                        }
                                        
                                        dataList.add(dataMap);
                                      }
                                } else if("J301Y".equals(formCd)) {
                                    //주택마련저축
                                      
                                      for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                        dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                        dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                          dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                          dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //취급기관
                                          dataMap.put("A6",((Element)childList2.get(dataIndex)).getAttributeValue("acc_no")); //계좌번호
                                          
                                        ele3 = (Element)childList2.get(dataIndex);
                                        childList3 = ele3.getChildren();
                                        
                                        for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                            dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                            dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                            
                                          if("goods_nm".equals(dataEtcName)) {
                                                  dataMap.put("A7",dataEtcValue); //저축명
                                          } else if("saving_gubn".equals(dataEtcName)) {
                                                    dataMap.put("A8",dataEtcValue); //저축구분
                                          } else if("reg_dt".equals(dataEtcName)) {
                                                    dataMap.put("A9",dataEtcValue); //가입일자
                                          } else if("com_cd".equals(dataEtcName)) {
                                                    dataMap.put("A10",dataEtcValue); //금융회사등 코드
                                          } else if("sum".equals(dataEtcName)) {
                                                    dataMap.put("A11",dataEtcValue); //납입금액계
                                          }
                                        }
                                        
                                        dataList.add(dataMap);
                                      }
                                } else if("J301Y".equals(formCd)) {
                                    //목돈 안드는 전세 이자상환액
                                      
                                      for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                        dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                        dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                          dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                          dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //취급기관
                                          dataMap.put("A6",((Element)childList2.get(dataIndex)).getAttributeValue("acc_no")); //계좌번호
                                          
                                        ele3 = (Element)childList2.get(dataIndex);
                                        childList3 = ele3.getChildren();
                                        
                                        for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                            dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                            dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                            
                                          if("lend_loan_amt".equals(dataEtcName)) {
                                                  dataMap.put("A7",dataEtcValue); //대출원금
                                          } else if("lend_dt".equals(dataEtcName)) {
                                                    dataMap.put("A8",dataEtcValue); //대출일자
                                          } else if("sum".equals(dataEtcName)) {
                                                    dataMap.put("A10",dataEtcValue); //연강합계액
                                          }
                                        }
                                        
                                        dataList.add(dataMap);
                                      }
                                } else if("K101M".equals(formCd)) {
                                    //소기업소상공인 공제부금
                                      
                                      for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                        dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                        dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                          dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("acc_no")); //공제계약번호,증서번호
                                          
                                        ele3 = (Element)childList2.get(dataIndex);
                                        childList3 = ele3.getChildren();
                                        
                                        for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                            dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                            dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                            
                                          if("start_dt".equals(dataEtcName)) {
                                                  dataMap.put("A5",dataEtcValue); //대상기간시작일
                                          } else if("end_dt".equals(dataEtcName)) {
                                                    dataMap.put("A6",dataEtcValue); //대상기간종료일
                                          } else if("pay_method".equals(dataEtcName)) {
                                                    dataMap.put("A7",dataEtcValue); //납입방법
                                          } else if("sum".equals(dataEtcName)) {
                                              dataMap.put("A8",((Element)childList3.get(insuIndex)).getAttributeValue("ddct")); //소득공제대상액
                                                    dataMap.put("A9",dataEtcValue); //납입금액계
                                          }
                                        }
                                        
                                        dataList.add(dataMap);
                                      }
                                } else if("L101Y".equals(formCd)) {
                                    //기부금
                                      
                                      for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                        dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                        dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                          dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                          dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //단체명
                                          dataMap.put("A6",((Element)childList2.get(dataIndex)).getAttributeValue("donation_cd")); //기부유형
                                          
                                        ele3 = (Element)childList2.get(dataIndex);
                                        childList3 = ele3.getChildren();
                                        
                                        for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                            dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                            dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                            
                                          if("sum".equals(dataEtcName)) {
                                                    dataMap.put("A7",dataEtcValue); //기부금액계
                                          }
                                        }
                                        
                                        dataList.add(dataMap);
                                      }
                                }            
                            }
                    }
                }
                Log.Debug("dataList ==== "+dataList);
                
            } else if(v_ret == 0) {
                throw new UserException("연말정산간소화 표준 전자문서가 아닙니다.");
            } else if(v_ret == -1) {
                throw new UserException("비밀번호가 맞지 않습니다.");
            } else if(v_ret == -2) {
                throw new UserException("PDF문서가 아니거나 손상된 문서입니다.");
            } else{
                throw new UserException("데이터 추출에 실패하였습니다.");
            }
        } catch( UserException ue) {
            throw new UserException(ue.getMessage());
        } catch( Exception ex ) {
            throw new Exception(ex);
        }
        
        /////////////// PDF 데이터 DB에 저장하기. /////////////////
        
        //쿼리 맵 가져오기
        Map queryMap = XmlQueryParser.getQueryMap(xmlPath+"/common/pdfUpload.xml");
        
        //DB 컨트롤.
        //사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
        Connection conn = DBConn.getConnection();
        int delCnt = 0;
        int rstCnt = 0;
        int fileDelCnt = 0;
        int fileRstCnt = 0;
        
        if(dataList != null && dataList.size() > 0 && conn != null) {
        
            //사용자가 직접 트랜젝션 관리
            conn.setAutoCommit(false);
            
            try{
                
                //기존 데이터 삭제.
                Map deleteMap = new HashMap();
                
                deleteMap.put("ssnEnterCd", ssnEnterCd);
                deleteMap.put("workYy", paramYear);
                deleteMap.put("adjustType", paramAdjustType);
                deleteMap.put("sabun", paramSabun);
                
                delCnt += DBConn.executeUpdate(conn, queryMap, "deletePdfInfo", deleteMap);
                
                //현재 데이터 입력.
                for(int idx = 0; idx < dataList.size(); idx++ ) {
                    String query = "";
                    Map mp = (Map)dataList.get(idx);
                    
                    rstCnt += DBConn.executeUpdate(conn, queryMap, "insertPdfInfo", mp);
                }
                
                //파일을 다른위치로 저장(파일 저장시 실패하면 롤빽될수 있도록).
                if(!fileItem.isFormField()) {
                    long fileSize = fileItem.getSize();

                    if(fileSize > 0) { 
                        String attFileNm = fileItem.getName().trim();
                        String saveFileNm = paramSabun+attFileNm.substring(attFileNm.lastIndexOf("."));
                        String dbfilePath = StringUtil.getPropertiesValue("HRFILE.PATH")+"/YEA_PDF/"+ssnEnterCd+"/"+paramYear+"/SUM";
                        String saveFilePath = "";
                        
                        String nfsUploadPath = StringUtil.getPropertiesValue("NFS.HRFILE.PATH");
                        if(nfsUploadPath != null && nfsUploadPath.length() > 0) {
                            saveFilePath = nfsUploadPath+StringUtil.getPropertiesValue("HRFILE.PATH")+"/YEA_PDF/"+ssnEnterCd+"/"+paramYear+"/SUM";
                        } else {
                            saveFilePath = StringUtil.getPropertiesValue("WAS.PATH")+StringUtil.getPropertiesValue("HRFILE.PATH")+"/YEA_PDF/"+ssnEnterCd+"/"+paramYear+"/SUM";
                        }
                        
                        //파일 정보  db저장
                        Map fileMp = new HashMap();
                        fileMp.put("ssnEnterCd", ssnEnterCd);
                        fileMp.put("workYy", paramYear);
                        fileMp.put("adjustType", paramAdjustType);
                        fileMp.put("sabun", paramSabun);
                        fileMp.put("docType", docType);
                        fileMp.put("docSeq", docSeq);
                        fileMp.put("filePath", dbfilePath);
                        fileMp.put("fileName", saveFileNm);
                        fileMp.put("ssnSabun", ssnSabun);
                        
                        delCnt += DBConn.executeUpdate(conn, queryMap, "deletePdfFileInfo", fileMp);
                        rstCnt += DBConn.executeUpdate(conn, queryMap, "insertPdfFileInfo", fileMp);
                    
                        //디렉토리 생성
                        File dir = new File(saveFilePath);
                        if(!dir.exists()) dir.mkdirs();
                        
                        File file = new File(saveFilePath, saveFileNm);
                        fileItem.write(file);
                    }
                }
                
                //커밋
                conn.commit();
            } catch(Exception e) {
                try {
                    //롤백
                    conn.rollback();
                } catch (Exception e1) {
                    Log.Error("[rollback Exception] " + e);
                }
                throw new Exception("PDF 데이터 insert중 오류가 발생하였습니다.\\n"+e.toString());
            } finally {
                DBConn.closeConnection(conn, null, null);
            }
        }
        
        /////////////////////// DB저장 및 파일업로드가 완료되었다면 프로시저 호출 //////////////////////////
        String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR"};
        String[] param = new String[]{"","",ssnEnterCd,paramYear,paramAdjustType,paramSabun,ssnSabun};

        String[] rstStr = DBConn.executeProcedure("P_CPN_YEA_PDF_ERRCHK_"+paramYear,type,param);
        
        if(rstStr[0] != null && "1".equals(rstStr[0])) {
            procMessage = rstStr[1];
        } else {
            throw new UserException("프로시저 실행중 오류가 발생하였습니다.\\n"+rstStr[1]);
        }
        
    } /* end of for */
    
    Log.Debug("정상 업로드 완료");

%>
    <script>
        parent.procYn("Y","업로드가 정상적으로 완료되었습니다.\n<%=procMessage%>");
    </script>
<%
} catch(UserException ue) {
    Log.Debug("[UserException]" + ue.getMessage());
%>
    <script>
        parent.procYn("N","<%=ue.getMessage()%>");
    </script>
<%
} catch(Exception ex) {
    Log.Error(ex);
%>
    <script>
        parent.procYn("N","<%=String.valueOf(ex)%>");
    </script>
<%
}
Log.Debug("==============================PDF 업로드 끝===============================");
%>
