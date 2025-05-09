<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%
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

        boolean isSuccess = false;

        /* [Step1] 전자문서 위변조 검증 */
        try {
            /* 진본성 검증 초기화 */
            //기존코드 start
//          TSSPdfTSTValidator.init(cacertPath, CertVerifyConst.NONE, null );
            //기존코드 end


            //원래주석 start
            // "/cacerts"는 API와 함께 배포되는 서버인증서(RootCA.cer,CA131000001.cer)가 저장된 위치로 각 시스템에 맞게 수정 가능
            /* 전자문서 검증 */
            //원래주석 end

            DSTSPDFSig dstsPdfsig = new DSTSPDFSig();

            //기존소스 start
//          int result = TSSPdfTSTValidator.validatorByte(pdfBytes,paramPwd,paramPwd);

//          if( result == 0 ){
//              //out.println("<!-- 검증 완료(진본) -->");
//              //continue;
//          } else {
//              String errMessage = "";
//              switch(result){
//                  case 101: errMessage = "진본성 검증 초기화에 문제가 있습니다."; break;
//                  case 201: errMessage = "PDF문서가 아닙니다."; break;
//                  case 202: errMessage = "타임스탬프가 발급되지 않은 문서 입니다."; break;
//                  case 203: errMessage = "변조된 문서 입니다."; break;
//                  case 204: errMessage = "비밀번호가 틀립니다."; break;
//                  case 205: errMessage = "손상된 문서입니다."; break;
//                  case 301: errMessage = "토큰정보 추출에 문제가 있습니다."; break;
//                  case 302: errMessage = "미지원 토큰정보 입니다."; break;
//                  case 401: errMessage = "CRL 목록의 시간이 지났거나 파기 되었습니다."; break;
//                  default : errMessage = "알수없는 에러입니다."; break;
//              }

//              throw new UserException(errMessage);
//          }
            //기존소스 end

            dstsPdfsig.init(pdfBytes);
            dstsPdfsig.tokenParse();

            isSuccess = dstsPdfsig.tokenVerify();

            if( isSuccess ) {

            }else{
                String errMessage = dstsPdfsig.getTstVerifyFailInfo();
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

            //기존소스 start
//          ezPDFExportFile pdf = new ezPDFExportFile();
            //기존소스 end

            ExportCustomFile pdf = new ExportCustomFile();

            if (isSuccess) {

            // 데이터 추출
            byte[] buf = pdf.NTS_GetFileBufEx(pdfBytes , paramPwd, "XML", ("utf8".equals(pdfBytesEnc)?false:true));

//          byte[] buf = pdf.NTS_GetFileBufEx(pdfBytes, paramPwd, "XML", true );
            int v_ret = pdf.NTS_GetLastError();

            Document document = null; // 문서

            //문서 정상
            if ( v_ret == 1 ) {
                String strXml = new String( buf , pdfBytesEnc);
                SAXBuilder saxBuilder = new SAXBuilder();
                document = saxBuilder.build(new ByteArrayInputStream(strXml.getBytes()));

                // 정상적으로 추출된 데이터 활용하는 로직 구현 부분
                //str = strXml;
                //Log.Debug(strXml);
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

                String manResId2 = "";
                String manName2 = "";

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
                    manResId2 = "";
                    manName2 = "";
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

                        /* 2014-11-24 JEKIM MODIFY */
                        // 2014 변경 사항 (A->B)
                        //임시처리
                        //if(!"A".equals(docType)) {
//                          if(!"B".equals(docType)) {
                        //    throw new UserException("PDF 파일이 연간요약본이 아닙니다.\\n연간요약본으로 업로드하여 주십시오.");
                        //}
                    } else if("form".equals(tagName)) {
                        //서식별 반복구간.
                        //서식코드
                        formCd = ((Element)childElementList.get(childIndex)).getAttributeValue("form_cd");

                        ele = (Element)childElementList.get(childIndex);
                        childList = ele.getChildren();

                        for(int manIndex = 0; manIndex < childList.size(); manIndex++ ) {
                            manResId = ((Element)childList.get(manIndex)).getAttributeValue("resid"); //주민등록번호
                            manName = ((Element)childList.get(manIndex)).getAttributeValue("name"); //성명

                            manResId2 = "";
                            manName2 = "";

                            //2019-11-08. 인적공제 인원을 비교하기 위해 PDF의 정보를 MAP에 담는다
                            if(chkPerMap.get(manResId) == null) {
                            	chkPerMap.put(manResId, manName);
                            }

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
                                            manResId2 = dataEtcValue;
                                        } else if("insu1_nm".equals(dataEtcName)) {
                                            dataMap.put("A9",dataEtcValue); //성명_주피보험자
                                            manName2 = dataEtcValue;
                                        } else if("insu2_resid_1".equals(dataEtcName)) {
                                            dataMap.put("A10",dataEtcValue); //주민등록번호_종피보험자_1
                                        } else if("insu2_nm_1".equals(dataEtcName)) {
                                            dataMap.put("A11",dataEtcValue); //성명_종피보험자_1
                                        } else if("insu2_resid_2".equals(dataEtcName)) {
                                            dataMap.put("A12",dataEtcValue); //주민등록번호_종피보험자_2
                                        } else if("insu2_nm_2".equals(dataEtcName)) {
                                            dataMap.put("A13",dataEtcValue); //성명_종피보험자_2
                                        } else if("insu2_resid_3".equals(dataEtcName)) {
                                            dataMap.put("A14",dataEtcValue); //주민등록번호_종피보험자_3
                                        } else if("insu2_nm_3".equals(dataEtcName)) {
                                            dataMap.put("A15",dataEtcValue); //성명_종피보험자_3
                                        } else if("sum".equals(dataEtcName)) {
                                            dataMap.put("A16",dataEtcValue); //납입금액계
                                        }
                                    }
                                    //2021-02-05. 인적공제 인원을 비교하기 위해 PDF의 정보를 MAP에 담는다
                                    if(!"".equals(manResId2) && chkPerMap.get(manResId2) == null) {
                                    	chkPerMap.put(manResId2, manName2);
                                    }
                                    dataList.add(dataMap);
                                }
                            }
                            else if("B101Y".equals(formCd)) {
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
                            }
                            else if("B201Y".equals(formCd)){
                            	//실손의료보험금(2020년 추가)

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
                                        } else if("insu_resid".equals(dataEtcName)) {
                                            dataMap.put("A8",dataEtcValue); //주민등록번호_수익자
                                        } else if("insu_nm".equals(dataEtcName)) {
                                            dataMap.put("A9",dataEtcValue); //성명_수익자
                                        } else if("sum".equals(dataEtcName)) {
                                            dataMap.put("A10",dataEtcValue); //수령금액계
                                        }
                                    }

                                    dataList.add(dataMap);
                            	}
                            }
                            else if("C102Y".equals(formCd)) {
                                //교육비(유초중고,대학,기타)

                                for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                    dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                    dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                    dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                    dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //학교명
                                    dataMap.put("A6",((Element)childList2.get(dataIndex)).getAttributeValue("edu_tp")); //교육비종류
                                    dataMap.put("A7",((Element)childList2.get(dataIndex)).getAttributeValue("edu_cl")); //교육비구분(일반/현장체험학습)

                                    ele3 = (Element)childList2.get(dataIndex);
                                    childList3 = ele3.getChildren();

                                    for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                        dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                        dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();

                                        if("sum".equals(dataEtcName)) {
                                            dataMap.put("A8",dataEtcValue); // 납입금액계
                                        }
                                    }

                                    dataList.add(dataMap);
                                }
                            }
                            else if("C202Y".equals(formCd)) {
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
                            }
                            else if("C301Y".equals(formCd)) {
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
                            }
                            else if("C401Y".equals(formCd)) {
                                //교육비(학자금대출원리금상환액)

                                for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                    dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                    dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                    dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                    dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //기관명

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
                            }
                            else if("C501Y".equals(formCd)) {
                                //교육비(수능교육비, 대학입학전형료)

                                for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                	dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                    dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                    dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                    dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //학교명
                                    dataMap.put("A6",((Element)childList2.get(dataIndex)).getAttributeValue("edu_tp")); //교육비종류
                                    dataMap.put("A7",((Element)childList2.get(dataIndex)).getAttributeValue("edu_end")); // 최종고교학력

                                    ele3 = (Element)childList2.get(dataIndex);
                                    childList3 = ele3.getChildren();

                                    for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                        dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                        dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();

                                        if("sum".equals(dataEtcName)) {
                                            dataMap.put("A8",dataEtcValue); // 납입금액계
                                        }
                                    }

                                    dataList.add(dataMap);
                                }
                            }
                            else if("D101Y".equals(formCd)) {
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
                            }
                            else if("E103Y".equals(formCd)) {
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
                                            dataMap.put("A8",dataEtcValue); //당해연도납입금액(ISA납입금액포함)
                                        } else if("tax_year_amt".equals(dataEtcName)) {
                                            dataMap.put("A9",dataEtcValue); //당해연도인출금액(ISA납입금액포함)
                                        } else if("ddct_bs_ass_amt".equals(dataEtcName)) {
                                            dataMap.put("A10",dataEtcValue); //순납입금액(ISA납입금액포함)
                                        } else if("isa_ann_tot_amt".equals(dataEtcName)) {
                                            dataMap.put("A11",dataEtcValue); //ISA계좌 만기전환납입금액
                                        } else if("isa_tax_year_amt".equals(dataEtcName)) {
                                            dataMap.put("A12",dataEtcValue); //ISA계좌 만기전환인출금액
                                        } else if("isa_ddct_bs_ass_amt".equals(dataEtcName)) {
                                            dataMap.put("A13",dataEtcValue); //ISA계좌 만기전환순납입금액
                                        }
                                    }

                                    dataList.add(dataMap);
                                }
                            }
                            else if("F103Y".equals(formCd)) {
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
                                            dataMap.put("A8",dataEtcValue); //계좌유형
                                        } else if("ann_tot_amt".equals(dataEtcName)) {
                                            dataMap.put("A9",dataEtcValue); //당해연도납입금액(ISA 납입금액포함)
                                        } else if("tax_year_amt".equals(dataEtcName)) {
                                            dataMap.put("A10",dataEtcValue); //당해연도인출금액(ISA 납입금액포함)
                                        } else if("ddct_bs_ass_amt".equals(dataEtcName)) {
                                            dataMap.put("A11",dataEtcValue); //순납입금액(ISA 납입금액포함)
                                        } else if("isa_ann_tot_amt".equals(dataEtcName)) {
                                            dataMap.put("A12",dataEtcValue); //ISA계좌 만기전환납입금액
                                        } else if("isa_tax_year_amt".equals(dataEtcName)) {
                                            dataMap.put("A13",dataEtcValue); //ISA계좌 만기전환인출금액
                                        } else if("isa_ddct_bs_ass_amt".equals(dataEtcName)) {
                                            dataMap.put("A14",dataEtcValue); //ISA계좌 만기전환순납입금액
                                        }
                                    }

                                    dataList.add(dataMap);
                                }
                            }
                            else if("G111Y".equals(formCd)) {
                                //2023 신용카드

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

                                        if("sum".equals(dataEtcName) 
                                        		&& (! "2".equals(((Element)childList2.get(dataIndex)).getAttributeValue("use_place_cd")))
                                        		&& (! "4".equals(((Element)childList2.get(dataIndex)).getAttributeValue("use_place_cd")))
                                        	) {// 도서공연, 전통시장은 1~3월 / 4~12월 금액으로 들어가도록 처리하기 위해 해당 조건에서 로직 안타게 수정
                                        	// 전통시장: 2 / 도서공연: 4
                                        	dataMap.put("A7",dataEtcValue); //납입금액계
                                            dataList.add(dataMap);
                                        }
                                        else if("tfhy_tdmr_sum".equals(dataEtcName)) {
                                        	dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);
                                        	dataMap.put("A10",dataEtcValue); //2023년 1~3월 전통시장합계
                                            dataList.add(dataMap);
                                        }
                                        else if("shfy_tdmr_sum".equals(dataEtcName)) {
                                        	dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);
                                        	dataMap.put("A11",dataEtcValue); //2023년 4~12월 전통시장합계
                                            dataList.add(dataMap);
                                        }
                                        else if("tfhy_isld_sum".equals(dataEtcName)) {
                                        	dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);
                                        	dataMap.put("A12",dataEtcValue); //2023년 1~3월 도서공연
                                            dataList.add(dataMap);
                                        }
                                        else if("shfy_isld_sum".equals(dataEtcName)) {
                                        	dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);
                                        	dataMap.put("A13",dataEtcValue); //2023년 4~12월 도서공연
                                            dataList.add(dataMap);
                                        }
                                    }

                                    //dataList.add(dataMap);
                                }
                            }
                            else if("G211M".equals(formCd)) {
	                            //2023 현금영수증

	                            for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
	                                dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

	                                dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
	                                dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("use_place_cd")); //종류

	                                ele3 = (Element)childList2.get(dataIndex);
	                                childList3 = ele3.getChildren();

	                                for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
	                                    dataEtcName = ((Element)childList3.get(insuIndex)).getName();
	                                    dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();

	                                    if("sum".equals(dataEtcName) 
                                        		&& (! "2".equals(((Element)childList2.get(dataIndex)).getAttributeValue("use_place_cd")))
                                        		&& (! "4".equals(((Element)childList2.get(dataIndex)).getAttributeValue("use_place_cd")))
                                        	) {
	                                    	// 도서공연, 전통시장은 1~3월 / 4~12월 금액으로 들어가도록 처리하기 위해 해당 조건에서 로직 안타게 수정
	                                    	// 주택임차료 합계 항목 추가에 따라 주택임차료도 포함(총급여 7천만원 초과 여부에 따라 주택임차료 금액 반영 여부를 처리하기 위해 a14 컬럼에 별도 저장)
	                                    	// 전통시장: 2 / 도서공연: 4 / 주택임차료: 8
	                                    	if("8".equals(((Element)childList2.get(dataIndex)).getAttributeValue("use_place_cd")))
	                                    		dataMap.put("A14", dataEtcValue); //납입금액계
	                                    	else
	                                    		dataMap.put("A7", dataEtcValue); //납입금액계
                                            dataList.add(dataMap);
                                        }
                                        else if("tfhy_tdmr_sum".equals(dataEtcName)) {
                                        	dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);
                                        	dataMap.put("A10",dataEtcValue); //2023년 1~3월 전통시장합계
                                            dataList.add(dataMap);
                                        }
                                        else if("shfy_tdmr_sum".equals(dataEtcName)) {
                                        	dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);
                                        	dataMap.put("A11",dataEtcValue); //2023년 4~12월 전통시장합계
                                            dataList.add(dataMap);
                                        }
                                        else if("tfhy_isld_sum".equals(dataEtcName)) {
                                        	dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);
                                        	dataMap.put("A12",dataEtcValue); //2023년 1~3월 도서공연
                                            dataList.add(dataMap);
                                        }
                                        else if("shfy_isld_sum".equals(dataEtcName)) {
                                        	dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);
                                        	dataMap.put("A13",dataEtcValue); //2023년 4~12월 도서공연
                                            dataList.add(dataMap);
                                        }
	                                }

	                                //dataList.add(dataMap);
	                            }
	                        }
                            else if("G311Y".equals(formCd)) {
                                //2023 직불카드등

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

                                        if("sum".equals(dataEtcName) 
                                        		&& (! "2".equals(((Element)childList2.get(dataIndex)).getAttributeValue("use_place_cd")))
                                        		&& (! "4".equals(((Element)childList2.get(dataIndex)).getAttributeValue("use_place_cd")))
                                        	) {// 도서공연, 전통시장은 1~3월 / 4~12월 금액으로 들어가도록 처리하기 위해 해당 조건에서 로직 안타게 수정
                                        	// 전통시장: 2 / 도서공연: 4
                                        	dataMap.put("A7",dataEtcValue); //납입금액계
                                            dataList.add(dataMap);
                                        }
                                        else if("tfhy_tdmr_sum".equals(dataEtcName)) {
                                        	dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);
                                        	dataMap.put("A10",dataEtcValue); //2023년 1~3월 전통시장합계
                                            dataList.add(dataMap);
                                        }
                                        else if("shfy_tdmr_sum".equals(dataEtcName)) {
                                        	dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);
                                        	dataMap.put("A11",dataEtcValue); //2023년 4~12월 전통시장합계
                                            dataList.add(dataMap);
                                        }
                                        else if("tfhy_isld_sum".equals(dataEtcName)) {
                                        	dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);
                                        	dataMap.put("A12",dataEtcValue); //2023년 1~3월 도서공연
                                            dataList.add(dataMap);
                                        }
                                        else if("shfy_isld_sum".equals(dataEtcName)) {
                                        	dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);
                                        	dataMap.put("A13",dataEtcValue); //2023년 4~12월 도서공연
                                            dataList.add(dataMap);
                                        }
                                    }

                                    //dataList.add(dataMap);
                                }
                            }
                            else if("G411Y".equals(formCd)) {
                                //2023 제로페이

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

                                        if("sum".equals(dataEtcName) 
                                        		&& (! "2".equals(((Element)childList2.get(dataIndex)).getAttributeValue("use_place_cd")))
                                        		&& (! "4".equals(((Element)childList2.get(dataIndex)).getAttributeValue("use_place_cd")))
                                        	) {// 도서공연, 전통시장은 1~3월 / 4~12월 금액으로 들어가도록 처리하기 위해 해당 조건에서 로직 안타게 수정
                                        	// 전통시장: 2 / 도서공연: 4
                                        	dataMap.put("A7",dataEtcValue); //납입금액계
                                            dataList.add(dataMap);
                                        }
                                        else if("tfhy_tdmr_sum".equals(dataEtcName)) {
                                        	dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);
                                        	dataMap.put("A10",dataEtcValue); //2023년 1~3월 전통시장합계
                                            dataList.add(dataMap);
                                        }
                                        else if("shfy_tdmr_sum".equals(dataEtcName)) {
                                        	dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);
                                        	dataMap.put("A11",dataEtcValue); //2023년 4~12월 전통시장합계
                                            dataList.add(dataMap);
                                        }
                                        else if("tfhy_isld_sum".equals(dataEtcName)) {
                                        	dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);
                                        	dataMap.put("A12",dataEtcValue); //2023년 1~3월 도서공연
                                            dataList.add(dataMap);
                                        }
                                        else if("shfy_isld_sum".equals(dataEtcName)) {
                                        	dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);
                                        	dataMap.put("A13",dataEtcValue); //2023년 4~12월 도서공연
                                            dataList.add(dataMap);
                                        }
                                    }

                                    //dataList.add(dataMap);
                                }
                            }

                            else if("J101Y".equals(formCd)) {
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
                            }
                            else if("J203Y".equals(formCd)) {
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
                            }
                            else if("J301Y".equals(formCd)) {
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
                            }
                            else if("J501Y".equals(formCd)) {
 								//월세액

                                for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                    dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                    dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                    dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("lsor_no")); //임대인번호
                                    dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("lsor_nm")); //임대인명

                                    ele3 = (Element)childList2.get(dataIndex);
                                    childList3 = ele3.getChildren();

                                    for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                        dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                        dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();

                                        if("start_dt".equals(dataEtcName)) {
                                            dataMap.put("A6",dataEtcValue); //임대차시작일자
                                        } else if("end_dt".equals(dataEtcName)) {
                                            dataMap.put("A7",dataEtcValue); //임대차종료일자
                                        } else if("adr".equals(dataEtcName)) {
                                            dataMap.put("A8",dataEtcValue); //계약서상 주소지
                                        } else if("area".equals(dataEtcName)) {
                                            dataMap.put("A9",dataEtcValue); //계약면적
                                        } else if("typeCd".equals(dataEtcName)) {
                                            dataMap.put("A10",dataEtcValue); //유형코드
                                        } else if("sum".equals(dataEtcName)) {
                                            dataMap.put("A11",dataEtcValue); //지급금액계
                                        }
                                        
                                        
                                        if(((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd").equals("G0037")){
                                        	dataMap.put("A12","10"); //월세구분(B90741) 공공임대주택 월세액
                                        }else if(((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd").equals("G0042")){
                                        	dataMap.put("A12","20"); //월세구분 신용카드 월세액
                                        }
                                    }

                                    dataList.add(dataMap);
                                }
                            }
                            else if("N102Y".equals(formCd)) {
                                //장기집합투자증권저축

                                for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                    dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                    dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                    dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                    dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //취급기관
                                    dataMap.put("A6",((Element)childList2.get(dataIndex)).getAttributeValue("secu_no")); //계좌번호

                                    ele3 = (Element)childList2.get(dataIndex);
                                    childList3 = ele3.getChildren();

                                    for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                        dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                        dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                        if(((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd").equals("G0029")){
                                        	dataMap.put("A8","50"); //저축구분
                                        }else if(((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd").equals("G0043")){
                                        	dataMap.put("A8","70"); //저축구분-청년형
                                        }



                                        if("fund_nm".equals(dataEtcName)) {
                                            dataMap.put("A7",dataEtcValue); //펀드명
                                        } else if("reg_dt".equals(dataEtcName)) {
                                            dataMap.put("A9",dataEtcValue); //가입일자
                                        } else if("com_cd".equals(dataEtcName)) {
                                            dataMap.put("A10",dataEtcValue); //금융회사등 코드
                                        } else if("sum".equals(dataEtcName)) {
                                            dataMap.put("A11",dataEtcValue); //연간합계액
                                        } else if("ddct_bs_ass_amt".equals(dataEtcName)) {
                                            dataMap.put("A12",dataEtcValue); //소득공제대상금액
                                        } else if("ctr_term_mm_cnt".equals(dataEtcName)) {
                                            dataMap.put("A13",dataEtcValue); //계약기간월수  2022귀속추가
                                        }
                                    }

                                    dataList.add(dataMap);
                                }
                            }
                            else if("K101M".equals(formCd)) {
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
                                        } else if("rule_yn".equals(dataEtcName)) {
                                            dataMap.put("A10",dataEtcValue); //개정규칙 적용 신청 여부 (2020년 추가)
                                        }
                                    }

                                    dataList.add(dataMap);
                                }
                            }
                            else if("L102Y".equals(formCd)) {
                                //2016 기부금
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
                                            dataMap.put("A7",dataEtcValue); //공제대상기부금액
                                        }
                                        if("sbdy_apln_sum".equals(dataEtcName)) {
                                            dataMap.put("A8",dataEtcValue); //기부장려금신청금액
                                        }
                                        if("conb_sum".equals(dataEtcName)) {
                                            dataMap.put("A9",dataEtcValue); //기부금액계
                                        }
                                    }

                                    dataList.add(dataMap);
                                }

                            }
                            else if("O101M".equals(formCd)) {
                                //2016 건강보험료
                                for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                    dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                    dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드

                                    ele3 = (Element)childList2.get(dataIndex);
                                    childList3 = ele3.getChildren();

                                    for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                        dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                        dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                        if("sum".equals(dataEtcName)) {
                                            dataMap.put("A4",((Element)childList3.get(insuIndex)).getAttributeValue("hi_yrs")); //건강보험연말정산금액
                                            dataMap.put("A5",((Element)childList3.get(insuIndex)).getAttributeValue("ltrm_yrs")); //장기요양연말정산금액
                                            dataMap.put("A6",((Element)childList3.get(insuIndex)).getAttributeValue("hi_ntf")); //건강보험(보수월액)고지금액합계
                                            dataMap.put("A7",((Element)childList3.get(insuIndex)).getAttributeValue("ltrm_ntf")); //장기요양(보수월액)고지금액합계
                                            dataMap.put("A8",((Element)childList3.get(insuIndex)).getAttributeValue("hi_pmt")); //건강보험(소득월액)납부금액합계
                                            dataMap.put("A9",((Element)childList3.get(insuIndex)).getAttributeValue("ltrm_pmt")); //장기요양(소득월액)납부금액합계
                                            dataMap.put("A10",dataEtcValue); //총합계
                                        }
                                    }

                                    dataList.add(dataMap);
                                }

                            }
                            else if("P102M".equals(formCd)) {
                                //2017 국민연금보험료
                                for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                    dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                    dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드

                                    ele3 = (Element)childList2.get(dataIndex);
                                    childList3 = ele3.getChildren();

                                    for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                        dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                        dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                        dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();
                                        if("sum".equals(dataEtcName)) {
                                            dataMap.put("A4",((Element)childList3.get(insuIndex)).getAttributeValue("sp_ntf")); //직장가입자소급고지금액합계
                                            dataMap.put("A5",((Element)childList3.get(insuIndex)).getAttributeValue("spym")); //추납보험료납부금액
                                            dataMap.put("A6",((Element)childList3.get(insuIndex)).getAttributeValue("jlc")); //실업크레딧납부금액
                                            dataMap.put("A7",((Element)childList3.get(insuIndex)).getAttributeValue("ntf")); //직장가입자 고지금액 합계
                                            dataMap.put("A8",((Element)childList3.get(insuIndex)).getAttributeValue("pmt")); //지역가입자 등 납부금액 합계
                                            dataMap.put("A9",dataEtcValue); //총합계
                                        }
                                    }

                                    dataList.add(dataMap);
                                }
                            }
                            else if("Q101Y".equals(formCd)) {
                                //2021 벤처기업투자신탁
                                for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                    dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                    dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                    dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                    dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //상호
                                    dataMap.put("A6",((Element)childList2.get(dataIndex)).getAttributeValue("secu_no")); //계좌번호

                                    ele3 = (Element)childList2.get(dataIndex);
                                    childList3 = ele3.getChildren();

                                    for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                        dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                        dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();

                                        if("fund_nm".equals(dataEtcName)) {
                                            dataMap.put("A7",dataEtcValue); //투자신탁명
                                        } else if("reg_dt".equals(dataEtcName)) {
                                        	dataMap.put("A8",dataEtcValue); //납입연도
                                        } else if("vnt_asct_cl_cd".equals(dataEtcName)) {
                                        	dataMap.put("A9",dataEtcValue); //벤처조합구분코드
                                        } else if("com_cd".equals(dataEtcName)) {
                                        	dataMap.put("A10",dataEtcValue); //금융기관코드
                                        } else if("sum".equals(dataEtcName)) {
                                        	dataMap.put("A11",dataEtcValue); //연간합계액
                                        }
                                    }

                                    dataList.add(dataMap);
                                }
                            }
                            else if("Q201Y".equals(formCd)) {
                            	//2020 벤처기업투자신탁
                                for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                    dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                    dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                    dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                    dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //상호
                                    dataMap.put("A6",((Element)childList2.get(dataIndex)).getAttributeValue("secu_no")); //계좌번호

                                    ele3 = (Element)childList2.get(dataIndex);
                                    childList3 = ele3.getChildren();

                                    for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                        dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                        dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();

                                        if("fund_nm".equals(dataEtcName)) {
                                            dataMap.put("A7",dataEtcValue); //투자신탁명
                                        } else if("reg_dt".equals(dataEtcName)) {
                                        	dataMap.put("A8",dataEtcValue); //납입연도
                                        } else if("vnt_asct_cl_cd".equals(dataEtcName)) {
                                        	dataMap.put("A9",dataEtcValue); //벤처조합구분코드
                                        } else if("com_cd".equals(dataEtcName)) {
                                        	dataMap.put("A10",dataEtcValue); //금융기관코드
                                        } else if("sum".equals(dataEtcName)) {
                                        	dataMap.put("A11",dataEtcValue); //연간합계액
                                        }
                                    }

                                    dataList.add(dataMap);
                                }
                            }
                            else if("Q301Y".equals(formCd)) {
                                //2019 벤처기업투자신탁
                                for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
                                    dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);

                                    dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); //자료코드
                                    dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); //사업자번호
                                    dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); //상호
                                    dataMap.put("A6",((Element)childList2.get(dataIndex)).getAttributeValue("secu_no")); //계좌번호

                                    ele3 = (Element)childList2.get(dataIndex);
                                    childList3 = ele3.getChildren();

                                    for(int insuIndex = 0; insuIndex < childList3.size(); insuIndex++) {
                                        dataEtcName = ((Element)childList3.get(insuIndex)).getName();
                                        dataEtcValue = ((Element)childList3.get(insuIndex)).getValue();

                                        if("fund_nm".equals(dataEtcName)) {
                                            dataMap.put("A7",dataEtcValue); //투자신탁명
                                        } else if("reg_dt".equals(dataEtcName)) {
                                            dataMap.put("A8",dataEtcValue); //납입연도
                                        } else if("vnt_asct_cl_cd".equals(dataEtcName)) {
                                            dataMap.put("A9",dataEtcValue); //벤처조합구분코드
                                        } else if("com_cd".equals(dataEtcName)) {
                                            dataMap.put("A10",dataEtcValue); //금융기관코드
                                        } else if("sum".equals(dataEtcName)) {
                                            dataMap.put("A11",dataEtcValue); //연간합계액
                                        }
                                    }

                                    dataList.add(dataMap);
                                }
                            }
                            else if("R101M".equals(formCd)) {
                            	// 장애인 증명자료. 22년 귀속 연말정산 때 신설
                            	for(int dataIndex = 0; dataIndex < childList2.size(); dataIndex++ ) {
	                            	dataMap = getDefaultDataMap(ssnEnterCd,ssnSabun,paramYear,paramAdjustType,paramSabun,docType,docSeq,formCd,manResId,manName);
	                            	//System.out.println("dataMap ==> " + dataMap.toString());
                            		
                            		dataMap.put("A3",((Element)childList2.get(dataIndex)).getAttributeValue("dat_cd")); // 자료코드
                                    dataMap.put("A4",((Element)childList2.get(dataIndex)).getAttributeValue("busnid")); // 사업자번호
                                    dataMap.put("A5",((Element)childList2.get(dataIndex)).getAttributeValue("trade_nm")); // 발급기관
                                    dataMap.put("A6",((Element)childList2.get(dataIndex)).getAttributeValue("pwd_cd")); // 장애내용
                                    
                                    //System.out.println("dataMap22 ==> " + dataMap.toString());
                                    dataList.add(dataMap);
                            	}
                            }
                        }
                    }
                }
                //Log.Debug("dataList ==== "+dataList);

            } else if(v_ret == 0) {
                throw new UserException("연말정산간소화 표준 전자문서가 아닙니다.");
            } else if(v_ret == -1) {
                throw new UserException("비밀번호가 맞지 않습니다.");
            } else if(v_ret == -2) {
                throw new UserException("PDF문서가 아니거나 손상된 문서입니다.");
            } else{
                throw new UserException("데이터 추출에 실패하였습니다.");
            }
            }
        } catch( UserException ue) {
            throw new UserException(ue.getMessage());
        } catch( Exception ex ) {
            throw new Exception(ex);
        }

%>
