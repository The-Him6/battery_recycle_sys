package com.battery.recycle.controller;

import com.battery.recycle.annotation.OssUpload;
import com.battery.recycle.common.Result;
import com.battery.recycle.constant.SystemConstants;
import com.battery.recycle.entity.ExchangeProduct;
import com.battery.recycle.exception.ForbiddenException;
import com.battery.recycle.service.IExchangeProductService;
import com.battery.recycle.service.IFileUploadService;
import com.battery.recycle.util.AuthUtil;
import com.battery.recycle.vo.ExchangeProductVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;

/**
 * 兑换商品控制器
 */
@Tag(name = "兑换商品管理", description = "积分商品的增删改查与图片上传")
@RestController
@RequestMapping("/exchange-product")
@RequiredArgsConstructor
public class ExchangeProductController {

        private final IExchangeProductService exchangeProductService;

        private final IFileUploadService fileUploadService;

    /**
     * 根据ID查询商品
     */
    @Operation(summary = "根据ID查询商品")
    @GetMapping("/{id}")
    public Result<ExchangeProductVO> getById(@PathVariable Long id) {
        ExchangeProduct product = exchangeProductService.getById(id);
        ExchangeProductVO vo = new ExchangeProductVO();
        BeanUtils.copyProperties(product, vo);
        return Result.success(vo);
    }

    /**
     * 查询所有商品（管理员）
     */
    @Operation(summary = "查询所有商品", description = "仅管理员可操作")
    @GetMapping("/list")
    public Result<List<ExchangeProductVO>> listAll() {
        AuthUtil.requireAdmin();
        List<ExchangeProduct> list = exchangeProductService.listAll();
        List<ExchangeProductVO> voList = new ArrayList<>();
        for (ExchangeProduct item : list) {
            ExchangeProductVO vo = new ExchangeProductVO();
            BeanUtils.copyProperties(item, vo);
            voList.add(vo);
        }
        return Result.success(voList);
    }

    /**
     * 查询商品列表（用户）
     */
    @Operation(summary = "查询商品列表", description = "用户可查看的全部上架商品")
    @GetMapping("/available")
    public Result<List<ExchangeProductVO>> listAvailable() {
        List<ExchangeProduct> list = exchangeProductService.listAll();
        List<ExchangeProductVO> voList = new ArrayList<>();
        for (ExchangeProduct item : list) {
            ExchangeProductVO vo = new ExchangeProductVO();
            BeanUtils.copyProperties(item, vo);
            voList.add(vo);
        }
        return Result.success(voList);
    }

    /**
     * 根据品牌查询
     */
    @Operation(summary = "根据品牌查询商品")
    @GetMapping("/brand/{brand}")
    public Result<List<ExchangeProductVO>> listByBrand(@PathVariable String brand) {
        List<ExchangeProduct> list = exchangeProductService.listByBrand(brand);
        List<ExchangeProductVO> voList = new ArrayList<>();
        for (ExchangeProduct item : list) {
            ExchangeProductVO vo = new ExchangeProductVO();
            BeanUtils.copyProperties(item, vo);
            voList.add(vo);
        }
        return Result.success(voList);
    }

    /**
     * 添加商品（管理员）
     */
    @Operation(summary = "添加商品", description = "仅管理员可操作")
    @PostMapping
    public Result<Void> add(@RequestBody ExchangeProduct product) {
        AuthUtil.requireAdmin();
        exchangeProductService.add(product);
        return Result.success("添加商品成功", null);
    }

    /**
     * 更新商品（管理员）
     */
    @Operation(summary = "更新商品", description = "仅管理员可操作")
    @PutMapping
    public Result<Void> update(@RequestBody ExchangeProduct product) {
        AuthUtil.requireAdmin();
        exchangeProductService.update(product);
        return Result.success("更新商品成功", null);
    }

    /**
     * 删除商品（管理员）
     */
    @Operation(summary = "删除商品", description = "仅管理员可操作")
    @DeleteMapping("/{id}")
    public Result<Void> deleteById(@PathVariable Long id) {
        AuthUtil.requireAdmin();
        exchangeProductService.deleteById(id);
        return Result.success("删除商品成功", null);
    }

    /**
     * 上传商品图片（管理员）
     */
    @Operation(summary = "上传商品图片", description = "仅管理员可操作，支持 jpeg/png/jpg/gif，最大 2MB")
    @PostMapping("/upload-image")
    @OssUpload(path = "image_url/", allowedTypes = { "image/jpeg", "image/png", "image/jpg", "image/gif" }, maxSize = 2
            * 1024 * 1024)
    public Result<String> uploadImage(@RequestParam("file") MultipartFile file) {
        AuthUtil.requireAdmin();

        String imageUrl = fileUploadService.uploadProductImage(file);
        return Result.success(SystemConstants.FILE_UPLOAD_SUCCESS, imageUrl);
    }
}