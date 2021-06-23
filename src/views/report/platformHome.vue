<template>
  <div class="boss">
    <!-- 第一行 -->
    <div class="first-row">
      <div>
        <h3>平台用户情况</h3>
        <ul>
          <li>
            <div>入驻学校数量</div>
            <div>2</div>
          </li>
          <li>
            <div>学校工作人员用户数</div>
            <div>2</div>
          </li>
          <li>
            <div>学校招生人员用户数</div>
            <div>2</div>
          </li>
          <li>
            <div>学生及家长用户数</div>
            <div>2</div>
          </li>
        </ul>
      </div>
      <div>
        <h3>财务情况总览</h3>
        <ul>
          <li>
            <div>今日流水收入</div>
            <div>2</div>
          </li>
          <li>
            <div>今日流水支出</div>
            <div>￥2</div>
          </li>
          <li>
            <div>总流水收入</div>
            <div>2</div>
          </li>
          <li>
            <div>总流水支出</div>
            <div>￥2</div>
          </li>
        </ul>
      </div>
    </div>
    <!-- 第二行 -->
    <h2>各高校用户情况</h2>
    <div id="main" style="width: 1800px; height: 400px"></div>
    <!-- 第三行 -->
    <div class="three-row">
      <div>
        <h3>平台收入支出情况</h3>
        <div id="comscholl" style="width: 1600px; height: 400px">
          <!-- 时间选择 -->
          <a-range-picker
            :ranges="{
              今天: [moment().startOf('day'), moment()],
              昨天: [moment().startOf('day').subtract(1, 'days'), moment().endOf('day').subtract(1, 'days')],
              一周: [moment().startOf('day').subtract(1, 'weeks'), moment()],
              两周: [moment().startOf('day').subtract(2, 'weeks'), moment()],
              一个月: [moment().startOf('day').subtract(1, 'months'), moment()],
              一年: [moment().startOf('day').subtract(1, 'years'), moment()],
            }"
            :showTime="false"
            format="YYYY/MM/DD"
            @change="onChange"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import moment from 'moment'
export default {
  name: 'Boss',
  data() {
    return {
      dateFormat: 'YYYY/MM/DD',
      monthFormat: 'YYYY/MM',
      size: 'default',
    }
  },
  computed: {},
  created() {},
  mounted() {
    this.drawChart(),
    this.comscholl()
  },
  methods: {
    moment,
    onChange(dates, dateStrings) {
      console.log('From: ', dates[0], ', to: ', dates[1])
      console.log('From: ', dateStrings[0], ', to: ', dateStrings[1])
    },
    drawChart() {
      // 基于准备好的dom，初始化echarts实例
      let myChart = this.$echarts.init(document.getElementById('main'))
      // 指定图表的配置项和数据
      let option = {
        title: {
          text: '',
        },
        tooltip: {},
        xAxis: {
          data: ['衬衫', '羊毛衫', '雪纺衫', '裤子', '高跟鞋', '袜子'],
        },
        yAxis: {},
        series: [
          {
            name: '销量',
            type: 'bar',
            data: [5, 20, 36, 10, 10, 20],
          },
        ],
      }
      // 使用刚指定的配置项和数据显示图表。
      myChart.setOption(option)
    },
    comscholl() {
      let comscholl = this.$echarts.init(document.getElementById('comscholl'))
      let option = {
        title: {},
        tooltip: {
          trigger: 'axis',
        },
        legend: {
          data: ['邮件营销', '联盟广告', '视频广告', '直接访问', '搜索引擎'],
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true,
        },
        toolbox: {
          feature: {
            saveAsImage: {},
          },
        },
        xAxis: {
          type: 'category',
          boundaryGap: false,
          data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
        },
        yAxis: {
          type: 'value',
        },
        series: [
          {
            name: '邮件营销',
            type: 'line',
            stack: '总量',
            data: [120, 132, 101, 134, 90, 230, 210],
          },
          {
            name: '联盟广告',
            type: 'line',
            stack: '总量',
            data: [220, 182, 191, 234, 290, 330, 310],
          },
          {
            name: '视频广告',
            type: 'line',
            stack: '总量',
            data: [150, 232, 201, 154, 190, 330, 410],
          },
          {
            name: '直接访问',
            type: 'line',
            stack: '总量',
            data: [320, 332, 301, 334, 390, 330, 320],
          },
          {
            name: '搜索引擎',
            type: 'line',
            stack: '总量',
            data: [820, 932, 901, 934, 1290, 1330, 1320],
          },
        ],
      }
      comscholl.setOption(option)
    }
  }
}
</script>
<style lang="less" scoped>
.boss {
  .first-row,
  .three-row {
    display: flex;
    > div {
      width: 49%;
      > ul {
        display: flex;
        li {
          flex: 1;
        }
      }
    }
  }
  .charts {
    display: flex;
    > div {
      &:nth-child(1) {
        flex: 3;
      }
      &:nth-child(2) {
        flex: 4;
      }
    }
  }
}
</style>