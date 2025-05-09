package com.hr.common.interfaceIf.hrm;

import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
public class SearchEmpController {

    @Autowired
    private SearchEmpService searchEmpService;

    @PostMapping("/searchEmp")
    public ResponseEntity<Map<String, Object>> searchEmp(@RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();

        try {
            Map<String, Object> result = new HashMap<>();
            result.put("result", searchEmpService.searchEmp(paramMap));
            return ResponseEntity.ok(result);
        } catch(Exception e) {
            throw new Exception("조회에 실패 하였습니다.");
        }
    }
}
