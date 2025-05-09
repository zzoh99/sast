package com.hr.wtm.domain;

import com.hr.common.exception.HrException;
import com.hr.common.util.DateUtil;
import com.hr.wtm.config.wtmLeaveCreMgr.dto.WtmUserLeaveDTO;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class WtmLeaveReCalc {

    private final List<WtmLeaveAppInfo> appliedLeavesList; // 신청된 근태 리스트
    private List<WtmUserLeaveDTO> resultList;

    public WtmLeaveReCalc(List<WtmLeaveAppInfo> appliedLeavesList, List<WtmUserLeaveDTO> generatedLeavesList) {
        this.appliedLeavesList = appliedLeavesList;
        this.resultList = generatedLeavesList;
    }

    /**
     * 연차개수 재계산
     */
    public void reCalc() {

        for (WtmLeaveAppInfo appInfo : appliedLeavesList) {

            double appCnt = appInfo.getAppDay();

            if (resultList.stream()
                    .noneMatch(dto -> isFiltered(appInfo, dto))) continue;

            int maxSeq;
            try {
                maxSeq = resultList.stream()
                        .filter(dto -> isFiltered(appInfo, dto))
                        .sorted(new WtmUserLeaveDTO.SYmdComparator())
                        .reduce((f, s) -> s)
                        .orElseThrow(() -> new HrException(""))
                        .getSeq();
            } catch(HrException e) {
                continue;
            }

            for (WtmUserLeaveDTO userDto : resultList.stream()
                    .filter(dto -> isFiltered(appInfo, dto))
                    .sorted(new WtmUserLeaveDTO.SYmdComparator()).collect(Collectors.toList())) {

                double restCnt = userDto.getRestCnt();

                if ((restCnt >= appCnt)
                        || (restCnt < appCnt && userDto.getSeq() == maxSeq && appInfo.getGntCdDTO().isMinusAllow())) {
                    userDto.setUsedCnt(userDto.getUsedCnt() + appCnt);
                    userDto.setRestCnt(userDto.getRestCnt() - appCnt);
                    userDto.setComCnt(userDto.getComCnt() - appCnt);

                    appCnt = 0;
                } else if (restCnt < appCnt && userDto.getSeq() != maxSeq && restCnt > 0) {
                    userDto.setUsedCnt(userDto.getUsedCnt() + restCnt);
                    userDto.setRestCnt(userDto.getRestCnt() - restCnt);
                    userDto.setComCnt(userDto.getComCnt() - restCnt);

                    appCnt = appCnt - restCnt;
                }

                if (appCnt <= 0) break;

            }
        }
    }

    private boolean isFiltered(WtmLeaveAppInfo appInfo, WtmUserLeaveDTO dto) {
        LocalDate ymd = DateUtil.getLocalDate(appInfo.getYmd());
        LocalDate sYmd = DateUtil.getLocalDate(dto.getUseSYmd());
        LocalDate eYmd = DateUtil.getLocalDate(dto.getUseEYmd());
        return appInfo.getEnterCd().equals(dto.getEnterCd())
                && appInfo.getSabun().equals(dto.getSabun())
                && appInfo.getBasicGntCd().equals(dto.getGntCd())
                && !ymd.isBefore(sYmd) && !ymd.isAfter(eYmd);
    }

    public List<WtmUserLeaveDTO> getResultList(String stdYmd) {
        if (resultList == null) return new ArrayList<>();
        if (stdYmd == null || stdYmd.isEmpty()) return resultList;

        return resultList.stream().filter(dto -> {
            LocalDate stdDate = DateUtil.getLocalDate(stdYmd);
            return !stdDate.isBefore(dto.getUseSDate()) && !stdDate.isAfter(dto.getUseEDate());
        }).collect(Collectors.toList());
    }
}
