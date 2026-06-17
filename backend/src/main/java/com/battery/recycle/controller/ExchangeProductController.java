package com.battery.recycle.controller;

import com.battery.recycle.util.AuthUtil;

import com.battery.recycle.annotation.OssUpload;
import com.battery.recycle.common.Result;
import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.entity.ExchangeProduct;
import com.battery.recycle.exception.BusinessException;
import com.battery.recycle.service.ExchangeProductService;
import com.battery.recycle.service.FileUploadService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * 兑换商品控制器
 */
@RestController
@RequestMapping("/exchange-product")
public class ExchangeProductController {

    @Resource
    private ExchangeProductService exchangeProductService;

    @Resource
    private FileUploadService fileUploadService;

    /**
     * 根据ID查询商品
     */
    @GetMapping("/{id}")
    public Result<ExchangeProduct> getById(@PathVariable Long id) {
        ExchangeProduct product = exchangeProductService.getById(id);
        return Result.success(product);
    }

    /**
     * 查询所有商品（管理员）
     */
    @GetMapping("/list")
    public Result<List<ExchangeProduct>> listAll() {
        Integer role = AuthUtil.getRole();
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }
        List<ExchangeProduct> list = exchangeProductService.listAll();
        return Result.success(list);
    }

    /**
     * 查询商品列表（用户）
     */
    @GetMapping("/available")
    public Result<List<ExchangeProduct>> listAvailable() {
        List<ExchangeProduct> list = exchangeProductService.listAll();
        return Result.success(list);
    }

    /**
     * 根据品牌查询
     */
    @GetMapping("/brand/{brand}")
    public Result<List<ExchangeProduct>> listByBrand(@PathVariable String brand) {
        List<ExchangeProduct> list = exchangeProductService.listByBrand(brand);
        return Result.success(list);
    }

    /**
     * 添加商品（管理员）
     */
    @PostMapping
    public Result<Void> add(@RequestBody ExchangeProduct product) {
        Integer role = AuthUtil.getRole();
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }
        exchangeProductService.add(product);
        return Result.success("添加商品成功", null);
    }

    /**
     * 更新商品（管理员）
     */
    @PutMapping
    public Result<Void> update(@RequestBody ExchangeProduct product) {
        Integer role = AuthUtil.getRole();
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }
        exchangeProductService.update(product);
        return Result.success("更新商品成功", null);
    }

    /**
     * 删除商品（管理员）
     */
    @DeleteMapping("/{id}")
    public Result<Void> deleteById(@PathVariable Long id) {
        Integer role = AuthUtil.getRole();
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }
        exchangeProductService.deleteById(id);
        return Result.success("删除商品成功", null);
    }

    /**
     * 上传商品图片（管理员）
     */
    @PostMapping("/upload-image")
    @OssUpload(path = "image_url/", allowedTypes = { "image/jpeg", "image/png", "image/jpg", "image/gif" }, maxSize = 2
            * 1024 * 1024)
    public Result<String> uploadImage(@RequestParam("file") MultipartFile file) {
        Integer role = AuthUtil.getRole();
        if (!role.equals(SystemConstants.ROLE_ADMIN)) {
            throw new BusinessException(SystemConstants.ADMIN_ONLY);
        }

        String imageUrl = fileUploadService.uploadProductImage(file);
        return Result.success(SystemConstants.FILE_UPLOAD_SUCCESS, imageUrl);
    }
}
