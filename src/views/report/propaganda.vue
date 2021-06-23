<template>
  <div class="boss">
    <!-- 第一行 -->
    <div class="first-row">
      <a-row style="margin-right: 5px">
        <a-col :span="24">
          <a-card :bordered="false">
            <a-card-grid style="width:20%;position: relative;" v-for="(item,index) in firstRow" :key="index">
              <div class="text" v-if="item.status==='N'">
                已设置
                <br>
                内容
              </div>
              <div class="text1" v-if="item.status==='Y'">
                未设置
                <br>
                内容
              </div>
              <h3>{{index+1}}.{{item.ModuleName}}：</h3>
              <h4>{{item.countName}}：{{item.count}}</h4>
              <h4>最后更新时间：{{item.date}}</h4>
            </a-card-grid>
          </a-card>
        </a-col>
      </a-row>
     <!-- <div style="background: #ececec; padding: 30px">-->
<!--        <a-card title="1.学校介绍111" :bordered="false" style="width: 300px">-->
<!--          <p>浏览量:</p>-->
<!--          <p>最后更新时间:</p>-->
<!--        </a-card>-->
<!--      </div> -->
    </div>
    <br>
    <!-- 第二行 -->
    <a-row>
      <a-col :span="24" style="width: 100%">
        <a-card :bordered="false" title="模块浏览量排行">
          <div id="main" style="width: 100%; height: 400px"></div>
        </a-card>
      </a-col>
    </a-row>
  </div>
</template>

<script>
import moment from 'moment'
import { axios } from '@/utils/request'
export default {
  name: 'Propaganda',
  computed: {},
  created() {},
  mounted() {
    this.drawChart()
    this.teamChart()
  },
  data() {
    return {
      firstRow:[]
    }
  },
  methods: {
    moment,
    onChange(dates, dateStrings) {
      console.log('From: ', dates[0], ', to: ', dates[1])
      console.log('From: ', dateStrings[0], ', to: ', dateStrings[1])
    },
    // 第一行
    teamChart(){
      axios
        .get(`/manage/recruitModule/PublicityReport`)
        .then((res) => {
          console.log(res,987654)
          this.firstRow = res.result
        })
        .catch((err) => {
          console.log(err)
        })
        .finally(() => {
        })
    },
    //  获取第二行
    drawChart() {
      axios
        .get(`/manage/recruitModule/BrowseRanking`)
        .then((res) => {
          let option = {
            title: {
              text: ''
            },
            tooltip: {},
            xAxis: {
              data: res.result.xAxis
              // data: ['衬衫', '羊毛衫', '雪纺衫', '裤子', '高跟鞋', '袜子'],
            },
            yAxis: {},
            series: [
              {
                // name: '销量',
                type: 'bar',
                // data: [5, 20, 36, 10, 10, 20],
                data: res.result.yAxis
              }
            ]
          }
          // option.series[0].data = res.result.yAxis
          // option.xAxis.data = res.result.xAxis\

          // 基于准备好的dom，初始化echarts实例
          let myChart = this.$echarts.init(document.getElementById('main'))
          // 使用刚指定的配置项和数据显示图表。
          myChart.setOption(option,true)

        })
        .catch((err) => {
          console.log(err)
        })
        .finally(() => {
        })
    },
  },
}
</script>
<style lang="less" scoped>
  .text{
    width: 50px;
    height: 50px;
    padding: 2.5px;
    border: 1px solid #6fd18c;
    color: #6fd18c;
    position: absolute;
    top: 0;
    right: 0%;
    border-radius: 50%;
    /*font-size: 12px;*/
    -moz-transform: rotate(50deg);
    -webkit-transform: rotate(50deg);
    display: block;
    position: absolute;
    filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=3);
    text-align: center;
  }
  .text1{
    width: 50px;
    height: 50px;
    padding: 2.5px;
    border: 1px solid red;
    color: red;
    position: absolute;
    top: 0;
    right: 0%;
    border-radius: 50%;
    /*font-size: 12px;*/
    -moz-transform: rotate(50deg);
    -webkit-transform: rotate(50deg);
    display: block;
    position: absolute;
    filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=3);
    text-align: center;
  }
</style>