package com.hr.api.front.login;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;


@Service("FrontLoginService")
public class FrontLoginService {

    @Inject
    @Named("Dao")
    private Dao dao;

}