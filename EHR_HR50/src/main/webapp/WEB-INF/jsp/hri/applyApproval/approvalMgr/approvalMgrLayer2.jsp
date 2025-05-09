<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<!-- ajax error -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>

<% request.setAttribute("uploadType", "appl"); %>
<script>
	$(function() {
	});


	$(document).ready(function () {
        // 계좌 폼 내부 탭
        $(".bank_account_form .tab_container .tab").click(function () {
            var $container = $(this).closest(".tab_container")
            var $bankForm = $(this).closest(".bank_account_form")

            $container.find(".tab").removeClass("active")
            $(this).addClass("active")

            var tabId = $(this).data("tab")
            $bankForm.find(".tab_content").removeClass("active")
            $bankForm.find("#" + tabId).addClass("active")
        })

        // 삭제 계좌 checkbox
        $(".form-checkbox").change(function () {
            $(this).closest(".checkbox_card").toggleClass("checked")
        })

        // 파일 확장자별 아이콘 매핑
        const getFileIconClass = (fileName) => {
            const ext = fileName.split(".").pop().toLowerCase()
            const iconMap = {
                // 이미지
                bmp: "bmp",
                jpg: "img",
                jpeg: "img",
                png: "img",
                gif: "img",
                // 문서
                doc: "word",
                docx: "word",
                pdf: "pdf",
                ppt: "ppt",
                pptx: "ppt",
                xls: "excel",
                xlsx: "excel",
                // 압축
                zip: "zip",
                rar: "zip",
                "7z": "zip"
            }

            return iconMap[ext] || "file" // 매핑되지 않은 확장자는 기본 파일 아이콘 사용
        }

        // 기존 파일 아이콘 설정
        $(".attached_files .file_item").each(function () {
            const fileName = $(this).find(".txt_body_sm").text()
            const iconClass = getFileIconClass(fileName)
            $(this).find(".icon.file").addClass(iconClass)
        })

        // 파일 첨부 처리
        $("#fileInput").change(function () {
            const files = this.files
            const attachedFiles = $(".attached_files")

            for (let i = 0; i < files.length; i++) {
                const fileName = files[i].name
                const iconClass = getFileIconClass(fileName)

                const fileElement = $(`
        <div class="file_item d-flex align-center gap-4 justify-between">
            <div class="d-flex align-center gap-4">
                <i class="icon file ${iconClass}"></i>
                <span class="txt_body_sm txt_tertiary">${fileName}</span>
            </div>
            <div class="d-flex align-center gap-4">
                <button class="remove_file" data-file="${fileName}">
                    <i class="mdi-ico txt_tertiary">close</i>
                </button>
            </div>
        </div>
    `)

                attachedFiles.append(fileElement)
            }
        })

        // 첨부 파일 삭제
        $(document).on("click", ".remove_file", function () {
            $(this).closest(".file_item").remove()
        })
    })
</script>
<div class="wide wrapper modal_layer ux_wrapper bg-gray">
	 <div class="modal_body approval">
        <div class="d-flex gap-16">
            <div class="card bg-white pa-24 rounded-16 flex-1 bank_account_form">
                <p class="txt_title_xs sb txt_left mb-12">신청내용</p>
                <div class="input_form mb-12">
                    <div class="input_form_item">
                        <div class="label">
                            <p class="txt_body_sm txt_secondary">신청서 종류</p>
                        </div>
                        <div class="label_content">
                            <div class="tab_container w-full ma-auto">
                                <ul>
                                    <li>
                                        <button class="tab active" data-tab="tab1">추가</button>
                                    </li>
                                    <li>
                                        <button class="tab" data-tab="tab2">삭제</button>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab_content active" id="tab1">
                    <div class="d-flex flex-col gap-20">
                        <div>
                            <div class="d-flex justify-end mb-4"><button class="btn outline">삭제</button></div>
                            <div class="input_form">
                                <div class="input_form_item">
                                    <div class="label">
                                        <p class="txt_body_sm txt_secondary">계좌구분</p>
                                    </div>
                                    <div class="label_content">
                                        <select class="custom_select" name="" id="">
                                            <option value="">선택</option>
                                            <option value="">선택</option>
                                            <option value="">선택</option>
                                            <option value="">선택</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="input_form_item">
                                    <div class="label">
                                        <p class="txt_body_sm txt_secondary">시작/종료일자</p>
                                    </div>
                                    <div class="label_content">
                                        <!-- 아래 img 태그는 지우시고 기존 개발에서 사용하시는대로 input.bbit-dp-input 에 .thin 클래스 추가하시면 됩니다. -->
                                        <div>
                                            <input type="text" id="searchYm1" name="tmpPayYmFrom" class="date2 bbit-dp-input" maxlength="7" autocomplete="off" placeholder="시작일자" /><img class="ui-datepicker-trigger" src="../assets/images/calendar.png" alt="" isshow="0" />
                                        </div>
                                        <div>
                                            <input type="text" id="searchYm2" name="tmpPayYmFrom" class="date2 bbit-dp-input" maxlength="7" autocomplete="off" placeholder="종료일자" /><img class="ui-datepicker-trigger" src="/common/orange/images/calendar.gif" alt="" isshow="0" />
                                        </div>
                                    </div>
                                </div>
                                <div class="input_form_item">
                                    <div class="label">
                                        <p class="txt_body_sm txt_secondary">은행명</p>
                                    </div>
                                    <div class="label_content">
                                        <select class="custom_select" name="" id="">
                                            <option value="">선택</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="input_form_item">
                                    <div class="label">
                                        <p class="txt_body_sm txt_secondary">계좌번호</p>
                                    </div>
                                    <div class="label_content">
                                        <input type="text" class="input_text txt_right" placeholder="계좌번호를 입력해주세요" />
                                    </div>
                                </div>
                                <div class="input_form_item">
                                    <div class="label">
                                        <p class="txt_body_sm txt_secondary">예금주</p>
                                    </div>
                                    <div class="label_content">
                                        <input type="text" class="input_text txt_right" placeholder="예금주 성함을 작성해주세요" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- <div>
                            <div class="d-flex justify-end mb-4"><button class="btn outline">삭제</button></div>
                            <div class="input_form">
                                <div class="input_form_item">
                                    <div class="label">
                                        <p class="txt_body_sm txt_secondary">계좌구분</p>
                                    </div>
                                    <div class="label_content">
                                        <select class="custom_select" name="" id="">
                                            <option value="">선택</option>
                                            <option value="">선택</option>
                                            <option value="">선택</option>
                                            <option value="">선택</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="input_form_item">
                                    <div class="label">
                                        <p class="txt_body_sm txt_secondary">시작/종료일자</p>
                                    </div>
                                    <div class="label_content">
                                        <div>
                                            <input type="text" id="searchYm1" name="tmpPayYmFrom" class="date2 bbit-dp-input" maxlength="7" autocomplete="off" placeholder="시작일자" /><img class="ui-datepicker-trigger" src="../assets/images/calendar.png" alt="" isshow="0" />
                                        </div>
                                        <div>
                                            <input type="text" id="searchYm2" name="tmpPayYmFrom" class="date2 bbit-dp-input" maxlength="7" autocomplete="off" placeholder="종료일자" /><img class="ui-datepicker-trigger" src="/common/orange/images/calendar.gif" alt="" isshow="0" />
                                        </div>
                                    </div>
                                </div>
                                <div class="input_form_item">
                                    <div class="label">
                                        <p class="txt_body_sm txt_secondary">은행명</p>
                                    </div>
                                    <div class="label_content">
                                        <select class="custom_select" name="" id="">
                                            <option value="">선택</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="input_form_item">
                                    <div class="label">
                                        <p class="txt_body_sm txt_secondary">계좌번호</p>
                                    </div>
                                    <div class="label_content">
                                        <input type="text" class="input_text txt_right" placeholder="계좌번호를 입력해주세요" />
                                    </div>
                                </div>
                                <div class="input_form_item">
                                    <div class="label">
                                        <p class="txt_body_sm txt_secondary">예금주</p>
                                    </div>
                                    <div class="label_content">
                                        <input type="text" class="input_text txt_right" placeholder="예금주 성함을 작성해주세요" />
                                    </div>
                                </div>
                            </div>
                        </div> -->
                    </div>

                    <div class="d-flex justify-center mt-32">
                        <button class="btn m outline">
                            <i class="mdi-ico mr-2">add</i>
                            추가
                        </button>
                    </div>
                </div>
                <div class="tab_content" id="tab2">
                    <!-- <div class="d-flex flex-col gap-12 justify-center align-center py-12">
                        <i class="icon no_list"></i>
                        <p class="txt_body_m txt_tertiary txt_center">
                            삭제할 계좌가 없습니다.
                            <br />
                            계좌를 추가해주세요.
                        </p>
                    </div> -->
                    <div class="d-flex flex-col gap-12 py-12">
                        <p class="txt_body_m txt_tertiary">• 삭제할 계좌를 선택 후 결재신청 해주세요</p>
                        <div class="card rounded-12 pa-24 checkbox_card">
                            <div class="checkbox_wrap mb-16">
                                <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                <label for="checkbox1" class="txt_title_xs sb">급여계좌</label>
                            </div>
                            <div class="label_text_group mb-8">
                                <div class="txt_body_sm">
                                    <span class="txt_secondary">시작/종료 일자</span>
                                    <span class="sb">2020-01-01~2024-12-31</span>
                                </div>
                            </div>
                            <div class="label_text_group">
                                <div class="txt_body_sm">
                                    <span class="txt_secondary">은행명</span>
                                    <span class="sb">신한은행</span>
                                </div>
                                <div class="txt_body_sm">
                                    <span class="txt_secondary">계좌번호</span>
                                    <span class="sb">123-45645-789918</span>
                                </div>
                                <div class="txt_body_sm">
                                    <span class="txt_secondary">예금주</span>
                                    <span class="sb">김이수</span>
                                </div>
                            </div>
                        </div>

                        <div class="card rounded-12 pa-24 checkbox_card">
                            <div class="checkbox_wrap mb-16">
                                <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                <label for="checkbox1" class="txt_title_xs sb">급여계좌</label>
                            </div>
                            <div class="label_text_group mb-8">
                                <div class="txt_body_sm">
                                    <span class="txt_secondary">시작/종료 일자</span>
                                    <span class="sb">2020-01-01~2024-12-31</span>
                                </div>
                            </div>
                            <div class="label_text_group">
                                <div class="txt_body_sm">
                                    <span class="txt_secondary">은행명</span>
                                    <span class="sb">신한은행</span>
                                </div>
                                <div class="txt_body_sm">
                                    <span class="txt_secondary">계좌번호</span>
                                    <span class="sb">123-45645-789918</span>
                                </div>
                                <div class="txt_body_sm">
                                    <span class="txt_secondary">예금주</span>
                                    <span class="sb">김이수</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- 신청서 하단 공통 -->
                <div class="mt-24">
                    <div class="mb-24">
                        <div class="d-flex justify-between align-center mb-8">
                            <div class="d-flex align-center gap-8 flex-1">
                                <p class="txt_title_xs sb txt_secondary">첨부파일</p>
                            </div>
                            <div class="d-flex align-center gap-8">
                                <input type="file" id="fileInput" style="display: none" multiple />
                                <button class="btn outline dark_gray" onclick="document.getElementById('fileInput').click()">파일첨부</button>
                            </div>
                        </div>
                        <div class="attached_files d-flex gap-4 flex-1 flex-col">
                            <div class="file_item d-flex align-center gap-4 justify-between">
                                <div class="d-flex align-center gap-4">
                                    <i class="icon file"></i>
                                    <span class="txt_body_sm txt_tertiary">보기 화면에서의 첨부파일 예시.zip</span>
                                </div>
                                <button class="download_file">
                                    <i class="mdi-ico txt_tertiary">file_download</i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="card rounded-16 pa-12-16-24">
                        <div class="d-flex justify-between align-center mb-8">
                            <p class="txt_title_xs sb txt_tertiary d-flex align-center gap-4">
                                <i class="mdi-ico txt_18">error</i>
                                	신청시 유의사항
                            </p>
                            <button class="btn outline dark_gray">다운로드</button>
                        </div>
                        <p class="pl-20 txt_body_sm txt_tertiary">
                            • 신청시 유의사항을 작성하는 영역입니다.
                            <br />
                            • 신청시 유의사항을 작성하는 영역입니다.
                        </p>
                    </div>
                </div>
                                        
            </div>
            
            <!-- 신청서 읽기 전용 폼 -->
            <!-- <div class="card bg-white pa-24 rounded-16 d-flex flex-col gap-16 flex-1">
              <div class="d-flex flex-col gap-24 flex-1 scroll-y">
                  <div class="bd-b">
                      <div class="d-flex justify-between align-center mb-16">
                          <div class="d-flex align-center gap-8 flex-1">
                              <p class="txt_title_xs sb txt_primary">신청내용</p>
                          </div>
                          <div class="d-flex align-center gap-8">
                              <button class="btn outline dark_gray">WEB 인쇄</button>
                          </div>
                      </div>
                      <div class="input_form mb-12 read_form">
                          <div class="input_form_item">
                              <div class="label">
                                  <p class="txt_body_sm txt_secondary">신청서 종류</p>
                              </div>
                              <div class="label_content">
                                  <p>국문재직증명서</p>
                              </div>
                          </div>
                      </div>
                  </div>
                  <div>
                      <div class="d-flex justify-between align-center mb-16">
                          <div class="d-flex align-center gap-8 flex-1">
                              <p class="txt_title_xs sb txt_primary">신청세부내역</p>
                          </div>
                      </div>
                      <div class="input_form mb-12 read_form">
                          <div class="input_form_item">
                              <div class="label">
                                  <p class="txt_body_sm txt_secondary">재직기간</p>
                              </div>
                              <div class="label_content">
                                  <p>2017-01-01~2024-02-02 (6년 11개월)</p>
                              </div>
                          </div>
                          <div class="input_form_item">
                              <div class="label">
                                  <p class="txt_body_sm txt_secondary">용도</p>
                              </div>
                              <div class="label_content">
                                  <p>관공서 제출용</p>
                              </div>
                          </div>
                          <div class="input_form_item">
                              <div class="label">
                                  <p class="txt_body_sm txt_secondary">주소</p>
                              </div>
                              <div class="label_content">
                                  <p>서울시 서초구 사평대로60 4-7층</p>
                              </div>
                          </div>
                          <div class="input_form_item">
                              <div class="label">
                                  <p class="txt_body_sm txt_secondary">제출처</p>
                              </div>
                              <div class="label_content">
                                  <p>국세청</p>
                              </div>
                          </div>
                          <div class="input_form_item">
                              <div class="label">
                                  <p class="txt_body_sm txt_secondary">기타</p>
                              </div>
                              <div class="label_content">
                                  <p>관공서 제출용</p>
                              </div>
                          </div>
                      </div>
                  </div>
                  <div class="mb-24">
                      <div class="d-flex justify-between align-center mb-8">
                          <div class="d-flex align-center gap-8 flex-1">
                              <p class="txt_title_xs sb txt_secondary">첨부파일</p>
                          </div>
                          <div class="d-flex align-center gap-8">
                              <input type="file" id="fileInput" style="display: none" multiple />
                              <button class="btn outline dark_gray">전체 다운로드</button>
                          </div>
                      </div>
                      <div class="attached_files d-flex gap-4 flex-1 flex-col">
                          <div class="file_item d-flex align-center gap-4 justify-between">
                              <div class="d-flex align-center gap-4">
                                  <i class="icon file"></i>
                                  <span class="txt_body_sm txt_tertiary">보기 화면에서의 첨부파일 예시.zip</span>
                              </div>
                              <button class="download_file">
                                  <i class="mdi-ico txt_tertiary">file_download</i>
                              </button>
                          </div>
                          <div class="file_item d-flex align-center gap-4 justify-between">
                              <div class="d-flex align-center gap-4">
                                  <i class="icon file"></i>
                                  <span class="txt_body_sm txt_tertiary">보기 화면에서의 첨부파일 예시.jpg</span>
                              </div>
                              <button class="download_file">
                                  <i class="mdi-ico txt_tertiary">file_download</i>
                              </button>
                          </div>
                          <div class="file_item d-flex align-center gap-4 justify-between">
                              <div class="d-flex align-center gap-4">
                                  <i class="icon file"></i>
                                  <span class="txt_body_sm txt_tertiary">보기 화면에서의 첨부파일 예시.ppt</span>
                              </div>
                              <button class="download_file">
                                  <i class="mdi-ico txt_tertiary">file_download</i>
                              </button>
                          </div>
                          <div class="file_item d-flex align-center gap-4 justify-between">
                              <div class="d-flex align-center gap-4">
                                  <i class="icon file"></i>
                                  <span class="txt_body_sm txt_tertiary">보기 화면에서의 첨부파일 예시.ppt</span>
                              </div>
                              <button class="download_file">
                                  <i class="mdi-ico txt_tertiary">file_download</i>
                              </button>
                          </div>
                          <div class="file_item d-flex align-center gap-4 justify-between">
                              <div class="d-flex align-center gap-4">
                                  <i class="icon file"></i>
                                  <span class="txt_body_sm txt_tertiary">보기 화면에서의 첨부파일 예시.ppt</span>
                              </div>
                              <button class="download_file">
                                  <i class="mdi-ico txt_tertiary">file_download</i>
                              </button>
                          </div>
                          <div class="file_item d-flex align-center gap-4 justify-between">
                              <div class="d-flex align-center gap-4">
                                  <i class="icon file"></i>
                                  <span class="txt_body_sm txt_tertiary">보기 화면에서의 첨부파일 예시.ppt</span>
                              </div>
                              <button class="download_file">
                                  <i class="mdi-ico txt_tertiary">file_download</i>
                              </button>
                          </div>
                      </div>
                  </div>
              </div>

              <div class="card rounded-12 py-12 d-flex justify-center align-center gap-24">
                  <p class="txt_body_sm txt_secondary">
                      출력/다운로드 가능 횟수
                      <span class="txt_primary sb">0/3</span>
                  </p>
                  <button class="btn m dark">
                      <i class="mdi-ico mr-2">print</i>
                      출력
                  </button>
              </div>
          </div> -->

			<!-- 결재영역 .footer_fixed 없애고 스타일 수정하여서 .card, .card > div, .footer 부분 컨텐츠 내용을 감싸는 div만 한 번 확인 부탁드려요 -->
            <div class="card bg-white pa-24 rounded-16 d-flex flex-col gap-16 flex-1 max-w-332">
		      <div class="d-flex flex-col gap-24 flex-1 scroll-y">
		          <div class="mb-24">
		              <div class="d-flex justify-between align-center mb-12">
		                  <p class="txt_title_xs sb">결재</p>
		                  <button class="btn outline dark_gray" id="open_modal15">
		                      <i class="mdi-ico mr-2">restart_alt</i>
		                      결재선변경
		                  </button>
		              </div>
		              <!-- 결재 신청 시에 사용 -->
		              <!-- <div class="d-flex justify-between align-center mb-12">
		                  <p class="txt_body_sm txt_secondary">결재방법</p>
		                  <select class="custom_select w-174" name="" id="">
		                      <option value="">담당결재</option>
		                  </select>
		              </div> -->
		              <div class="card d-flex justify-between align-center txt_body_sm mb-12">
		                  <p class="txt_secondary">결재방법</p>
		                  <p class="sb">담당결재</p>
		              </div>
		
		              <!-- timeline-item 에 상태에 따라 completed, active, rejected 클래스 추가 -->
		              <div class="timeline mb-24">
		                  <div class="timeline-item pb-8 completed">
		                      <div class="card rounded-12 pa-16 d-flex gap-12">
		                          <span class="step_num">
		                              <span>1</span>
		                          </span>
		                          <div class="flex-1">
		                              <div class="d-flex gap-8 align-center justify-between">
		                                  <p class="txt_title_xs sb mb-2">김이수</p>
		                                  <span class="chip sm status">처리완료</span>
		                              </div>
		                              <div class="desc_divider_wrap mb-8">
		                                  <span>솔루션개발팀</span>
		                                  <span>대리</span>
		                              </div>
		                              <p class="txt_body_sm txt_tertiary">2024-10-30 09:00</p>
		                          </div>
		                      </div>
		                      <textarea name="" id="" class="mt-8 h-70" placeholder="의견을 작성해주세요"></textarea>
		                  </div>
		
		                  <div class="timeline-item pb-8 active">
		                      <div class="card rounded-12 pa-16 d-flex gap-12">
		                          <span class="step_num">
		                              <span>2</span>
		                          </span>
		                          <div class="flex-1">
		                              <div class="d-flex gap-8 align-center justify-between">
		                                  <p class="txt_title_xs sb mb-2">김이수</p>
		                                  <span class="chip sm status">결재처리중</span>
		                              </div>
		                              <div class="desc_divider_wrap mb-8">
		                                  <span>솔루션개발팀</span>
		                                  <span>대리</span>
		                              </div>
		                              <p class="txt_body_sm txt_tertiary">2024-10-30 09:00</p>
		                          </div>
		                      </div>
		                  </div>
		
		                  <div class="timeline-item pb-8 rejected">
		                      <div class="card rounded-12 pa-16 d-flex gap-12">
		                          <span class="step_num">
		                              <span>3</span>
		                          </span>
		                          <div class="flex-1">
		                              <div class="d-flex gap-8 align-center justify-between">
		                                  <p class="txt_title_xs sb mb-2">김이수</p>
		                                  <span class="chip sm status">결재반려</span>
		                              </div>
		                              <div class="desc_divider_wrap mb-8">
		                                  <span>솔루션개발팀</span>
		                                  <span>대리</span>
		                              </div>
		                              <p class="txt_body_sm txt_tertiary">2024-10-30 09:00</p>
		                          </div>
		                      </div>
		                  </div>
		                  <div class="timeline-item pb-8">
		                      <div class="card rounded-12 pa-16 d-flex gap-12">
		                          <span class="step_num">
		                              <span>4</span>
		                          </span>
		                          <div class="flex-1">
		                              <div class="d-flex gap-8 align-center justify-between">
		                                  <p class="txt_title_xs sb mb-2">김이수</p>
		                                  <span class="chip sm status">기안</span>
		                              </div>
		                              <div class="desc_divider_wrap mb-8">
		                                  <span>솔루션개발팀</span>
		                                  <span>대리</span>
		                              </div>
		                              <p class="txt_body_sm txt_tertiary">2024-10-30 09:00</p>
		                          </div>
		                      </div>
		                  </div>
		                  <div class="timeline-item pb-8">
		                      <div class="proxy_approver">
		                          <div class="card rounded-12 pa-12-16">
		                              <p class="txt_body_sm sb mb-2">김철수</p>
		                              <div class="desc_divider_wrap">
		                                  <span>솔루션개발팀</span>
		                                  <span>대리</span>
		                              </div>
		                          </div>
		                          <div class="card rounded-12 pa-16 d-flex gap-12">
		                              <span class="step_num">
		                                  <span>4</span>
		                              </span>
		                              <div class="flex-1">
		                                  <div class="d-flex gap-8 align-center justify-between">
		                                      <div class="d-flex gap-4 align-center mb-2">
		                                          <p class="txt_title_xs sb txt-leading-100">김이수</p>
		                                          <span class="chip sm scarlet">대결자</span>
		                                      </div>
		                                      <span class="chip sm status">기안</span>
		                                  </div>
		                                  <div class="desc_divider_wrap mb-8">
		                                      <span>솔루션개발팀</span>
		                                      <span>대리</span>
		                                  </div>
		                                  <p class="txt_body_sm txt_tertiary">2024-10-30 09:00</p>
		                              </div>
		                          </div>
		                      </div>
		                  </div>
		              </div>
		              <div>
		                  <p class="txt_title_xs sb txt_left mb-12 txt_secondary">참조</p>
		
		                  <div class="d-flex flex-col gap-8">
		                      <div class="card rounded-12 pa-12-16">
		                          <p class="txt_body_sm sb mb-2">김철수</p>
		                          <div class="desc_divider_wrap">
		                              <span>솔루션개발팀</span>
		                              <span>대리</span>
		                          </div>
		                      </div>
		                      <div class="card rounded-12 pa-12-16">
		                          <p class="txt_body_sm sb mb-2">김철수</p>
		                          <div class="desc_divider_wrap">
		                              <span>솔루션개발팀</span>
		                              <span>대리</span>
		                          </div>
		                      </div>
		                      <div class="card rounded-12 pa-12-16">
		                          <p class="txt_body_sm sb mb-2">김철수</p>
		                          <div class="desc_divider_wrap">
		                              <span>솔루션개발팀</span>
		                              <span>대리</span>
		                          </div>
		                      </div>
		                  </div>
		              </div>
		          </div>
		      </div>
		      <div class="footer">
		          <button class="btn lg primary w-full">
		              <i class="mdi-ico mr-4">check</i>
		              결재신청
		          </button>
		          <!-- <button class="btn lg dark w-full">회수</button> -->
		          <!-- <button class="btn lg outline w-full">취소신청</button> -->
		          <!-- <button class="btn lg outline w-full">변경신청</button> -->
		          <!-- <button class="btn lg peach w-full">
		              <i class="mdi-ico mr-4">backspace</i>
		              반려
		          </button> -->
		          <!-- <button class="btn lg primary w-full">
		              <i class="mdi-ico mr-4">check</i>
		              결재
		          </button> -->
		      </div>
		  </div>
        </div>
    </div>
</div>