package com.battery.recycle.service;

import com.battery.recycle.entity.BatteryType;

import java.util.List;

/**
 * 电池类型服务接口。
 */
public interface IBatteryTypeService {

    BatteryType getById(Long id);

    List<BatteryType> listAll();

    List<BatteryType> listEnabled();

    void add(BatteryType batteryType);

    void update(BatteryType batteryType);

    void deleteById(Long id);
}
