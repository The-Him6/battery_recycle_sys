<template>
  <div class="statistics-page">
    <div class="page-header">
      <el-radio-group v-model="timeRange" @change="loadChart">
        <el-radio-button label="7days">最近七天</el-radio-button>
        <el-radio-button label="1year">一年</el-radio-button>
        <el-radio-button label="all">全部</el-radio-button>
      </el-radio-group>
    </div>
    <el-card class="custom-card chart-card" shadow="hover">
      <div ref="chartRef" class="chart-container"></div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, nextTick, onMounted, onBeforeUnmount } from 'vue'
import * as echarts from 'echarts'
import { countByDate, countByMonth, countByYear } from '@/api/statistics'

const timeRange = ref('7days')
const chartRef = ref(null)
let chartInstance = null

const loadChart = async () => {
  let data = []
  let xAxisData = []
  let seriesData = []
  let titleText = ''
  let xAxisName = ''

  if (timeRange.value === '7days') {
    const res = await countByDate(7)
    data = res.data || []
    xAxisData = data.map(item => {
      const date = new Date(item.date)
      return `${date.getMonth() + 1}/${date.getDate()}`
    })
    seriesData = data.map(item => item.totalCount)
    titleText = '最近七天回收趋势'
    xAxisName = '日期'
  } else if (timeRange.value === '1year') {
    const res = await countByMonth()
    data = res.data || []
    xAxisData = data.map(item => `${item.year}-${String(item.month).padStart(2, '0')}`)
    seriesData = data.map(item => item.totalCount)
    titleText = '近一年回收趋势（按月）'
    xAxisName = '月份'
  } else {
    const res = await countByYear()
    data = res.data || []
    xAxisData = data.map(item => `${item.year}年`)
    seriesData = data.map(item => item.totalCount)
    titleText = '全部回收趋势（按年）'
    xAxisName = '年份'
  }

  await nextTick()
  if (!chartInstance) {
    chartInstance = echarts.init(chartRef.value)
  }

  chartInstance.setOption({
    title: { text: titleText, left: 'center', textStyle: { color: '#606266', fontSize: 16 } },
    tooltip: {
      trigger: 'axis',
      formatter: (params) => `${params[0].name}<br/>回收数量: ${params[0].value}`
    },
    xAxis: {
      type: 'category',
      name: xAxisName,
      data: xAxisData,
      axisLabel: { color: '#606266', rotate: timeRange.value === '1year' ? 45 : 0 }
    },
    yAxis: { type: 'value', name: '数量', axisLabel: { color: '#606266' } },
    series: [{
      data: seriesData,
      type: 'line',
      smooth: true,
      itemStyle: { color: '#1890ff' },
      areaStyle: {
        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
          { offset: 0, color: 'rgba(24, 144, 255, 0.3)' },
          { offset: 1, color: 'rgba(24, 144, 255, 0.05)' }
        ])
      }
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
  gap: 16px;
}

.header-actions {
  display: flex;
  gap: 12px;
  align-items: center;
  flex-wrap: wrap;
}

.chart-container {
  height: 460px;
}
</style>

