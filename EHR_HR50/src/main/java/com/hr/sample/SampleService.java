package com.hr.sample;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 샘플 Service
 *
 * @author ParkMoohun
 *
 */
@Service("SampleService")
public class SampleService{

	@Inject
	@Named("Dao")
	private Dao dao;

}