package com.battery.recycle.service;

import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.entity.ExchangeProduct;
import com.battery.recycle.exception.BusinessException;
import com.battery.recycle.mapper.ExchangeProductMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 兑换商品服务类
 */
@Service
public class ExchangeProductService {

    @Autowired
    private ExchangeProductMapper exchangeProductMapper;

    /**
     * 根据ID查询商品
     */
    public ExchangeProduct getById(Long id) {
        ExchangeProduct product = exchangeProductMapper.getById(id);
        if (product == null) {
            throw new BusinessException("商品不存在");
        }
        return product;
    }

    /**
     * 查询所有商品
     */
    public List<ExchangeProduct> listAll() {
        return exchangeProductMapper.listAll();
    }

    /**
     * 查询上架的商品
     */
    public List<ExchangeProduct> listAvailable() {
        return exchangeProductMapper.listAvailable();
    }

    /**
     * 根据品牌查询
     */
    public List<ExchangeProduct> listByBrand(String brand) {
        return exchangeProductMapper.listByBrand(brand);
    }

    /**
     * 添加商品
     */
    public void add(ExchangeProduct product) {
        if (product.getStatus() == null) {
            product.setStatus(1);
        }
        if (product.getPointsRequired() == null) {
            product.setPointsRequired(1000);
        }
        exchangeProductMapper.insert(product);
    }

    /**
     * 更新商品
     */
    public void update(ExchangeProduct product) {
        ExchangeProduct existProduct = exchangeProductMapper.getById(product.getId());
        if (existProduct == null) {
            throw new BusinessException("商品不存在");
        }
        exchangeProductMapper.update(product);
    }

    /**
     * 删除商品
     */
    public void deleteById(Long id) {
        ExchangeProduct product = exchangeProductMapper.getById(id);
        if (product == null) {
            throw new BusinessException("商品不存在");
        }
        exchangeProductMapper.deleteById(id);
    }

    /**
     * 更新库存
     */
    public boolean updateStock(Long id, Integer quantity) {
        int result = exchangeProductMapper.updateStock(id, quantity);
        return result > 0;
    }
}




































