<template>
  <div class="statistics-page">
    <el-card class="custom-card chart-card" shadow="hover">
      <div ref="chartRef" class="chart-container"></div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick, onBeforeUnmount } from 'vue'
import * as echarts from 'echarts'
import { countByCity } from '@/api/statistics'

const chartRef = ref(null)
let chartInstance = null

const loadChart = async () => {
  const res = await countByCity(5)
  const data = res.data || []
  await nextTick()
  if (!chartInstance) {
    chartInstance = echarts.init(chartRef.value)
  }
  chartInstance.setOption({
    title: {
      text: '地区回收排行',
      left: 'center',
      textStyle: { color: '#606266', fontSize: 16 }
    },
    tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
    xAxis: {
      type: 'value',
      name: '数量',
      axisLabel: { color: '#606266' }
    },
    yAxis: {
      type: 'category',
      data: data.map(item => item.cityName),
      axisLabel: { color: '#606266' }
    },
    series: [{
      data: data.map(item => item.totalCount),
      type: 'bar',
      itemStyle: {
        color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [
          { offset: 0, color: '#0f766e' },
          { offset: 1, color: '#2dd4bf' }
        ])
      },
      label: { show: true, position: 'right', color: '#606266' }
    }]
  })
}

onMounted(loadChart)
onBeforeUnmount(() => chartInstance?.dispose())
</script>

<style scoped>
.statistics-page {
  animation: fadeIn 0.5s ease;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.chart-container {
  height: 460px;
}
</style>

