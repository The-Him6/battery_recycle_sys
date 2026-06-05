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
import { countByBatteryType } from '@/api/statistics'

const chartRef = ref(null)
let chartInstance = null

const loadChart = async () => {
  const res = await countByBatteryType()
  const data = res.data || []
  await nextTick()
  if (!chartInstance) {
    chartInstance = echarts.init(chartRef.value)
  }
  chartInstance.setOption({
    title: {
      text: '电池种类占比',
      left: 'center',
      textStyle: { color: '#606266', fontSize: 16 }
    },
    tooltip: { trigger: 'item', formatter: '{b}: {c}个 ({d}%)' },
    legend: { orient: 'vertical', left: 'left', textStyle: { color: '#606266' } },
    series: [{
      type: 'pie',
      radius: ['40%', '70%'],
      avoidLabelOverlap: false,
      itemStyle: {
        borderRadius: 10,
        borderColor: '#fff',
        borderWidth: 2
      },
      label: { show: true, formatter: '{b}\n{d}%' },
      emphasis: { label: { show: true, fontSize: 16, fontWeight: 'bold' } },
      data: data.map(item => ({ name: item.batteryTypeName, value: item.totalCount })),
      color: ['#1890ff', '#52c41a', '#faad14', '#f5222d', '#722ed1']
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

