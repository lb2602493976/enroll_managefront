<template>
  <div class="boss">
    <!-- 第一行 -->
    <div class="first-row">
      <a-row style="margin-right: 5px">
        <a-col :span="24">
          <a-card :bordered="false" title="招生团队总览">
            <a-card-grid style="width:25%;">
              <h3>招生团队数</h3>
              <span>{{cardDetail.teamCount}}人</span>
            </a-card-grid>
            <a-card-grid style="width:25%">
              <h3>团队成员数</h3>
              <span>{{cardDetail.MemberNum}}人</span>
            </a-card-grid>
            <a-card-grid style="width:25%">
              <h3>团队招生总数</h3>
              <span>{{cardDetail.recruitCount}}人</span>
            </a-card-grid>
            <a-card-grid style="width:25%">
              <h3>看校学生总数</h3>
              <span>{{cardDetail.stuComeCount}}人</span>
            </a-card-grid>
          </a-card>
        </a-col>
      </a-row>
      <a-row style="margin-left: 5px">
        <a-col :span="24">
          <a-card :bordered="false" title="退费情况总览">
            <!--            <div style="display:flex;justify-content: space-between;">-->
            <a-card-grid style="width:25%;text-align:center">
              <h3>已退预报名费人数</h3>
              <span>{{cardDetail.retreatCount}}人</span>
            </a-card-grid>
            <a-card-grid style="width:25%;text-align:center">
              <h3>已退预报名费金额</h3>
              <span>{{cardDetail.refundedAmount}}元</span>
            </a-card-grid>
            <a-card-grid style="width:25%;text-align:center">
              <h3>待退预报名费人数</h3>
              <span>{{cardDetail.waitretreat}}人</span>
            </a-card-grid>
            <a-card-grid style="width:25%;text-align:center">
              <h3>待退预报名费金额</h3>
              <span>{{cardDetail.norefundedAmount}}元</span>
            </a-card-grid>
            <!--            </div>-->
          </a-card>
        </a-col>
      </a-row>
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
    <br>
    <!-- 第三行 -->
    <div class="three-row">
      <a-row>
        <a-col :span="24" style="width: 100%">
          <a-card :bordered="false" title="团队任务完成情况">
            <div id="team" style="width: 100%; height: 450px"></div>
          </a-card>
        </a-col>
      </a-row>
      <!--      <div>-->
      <!--        <h3>团队任务完成情况</h3>-->
      <!--        <div id="team" style="width: 800px; height: 400px"></div>-->
      <!--      </div>-->
      <a-row style="margin-left: 10px">
        <a-col :span="24" style="width: 100%">
          <a-card :bordered="false" title="看校接待情况">
            <div style="margin-bottom: 19px">
              <!-- 时间选择 -->
              <a-range-picker
                :ranges="{
              今天: [moment().startOf('day'), moment()],
              昨天: [moment().startOf('day').subtract(1, 'days'), moment().endOf('day').subtract(1, 'days')],
              一周: [moment().startOf('day').subtract(1, 'weeks'), moment()],
              两周: [moment().startOf('day').subtract(2, 'weeks'), moment()],
              一个月: [moment().startOf('day').subtract(1, 'months'), moment()],
              // 一年: [moment().startOf('day').subtract(1, 'years'), moment()],
            }"
                :default-value="[moment().startOf('day').subtract(1, 'weeks'), moment()]"
                :showTime="false"
                format="YYYY-MM-DD"
                @change="onChangeThreeRight"
              />
            </div>
            <div id="comscholl" style="width: 100%; height: 400px"></div>
          </a-card>
        </a-col>
      </a-row>
    </div>
    <br>
    <!-- 第四行 -->
    <div>
      <a-row>
        <a-col :span="24">
          <a-card :bordered="false" title="团队情况走势" style="width: 100%">
            <div>
              <a-range-picker
                :ranges="{
            今天: [moment().startOf('day'), moment()],
            昨天: [moment().startOf('day').subtract(1, 'days'), moment().endOf('day').subtract(1, 'days')],
            一周: [moment().startOf('day').subtract(1, 'weeks'), moment()],
            两周: [moment().startOf('day').subtract(2, 'weeks'), moment()],
            一个月: [moment().startOf('day').subtract(1, 'months'), moment()],
            一年: [moment().startOf('day').subtract(1, 'years'), moment()],
          }"
                :default-value="[moment().startOf('day').subtract(1, 'weeks'), moment()]"
                :showTime="false"
                format="YYYY-MM-DD"
                @change="onChange"
              />
              <a-radio-group v-model="size" @change="onChangeButton(size)">
                <a-radio-button value="1"> 招生人数</a-radio-button>
                <a-radio-button value="2"> 看校人数</a-radio-button>
                <a-radio-button value="3"> 退费人数</a-radio-button>
              </a-radio-group>
            </div>
            <div class="charts" style="width: 100%">
              <div id="pie" style="width: 50%; height: 300px"></div>
              <div id="trend" style="width: 50%; height: 300px"></div>
            </div>
          </a-card>
        </a-col>
      </a-row>
    </div>
  </div>
</template>

<script>
  import moment from 'moment'
  import { axios } from '@/utils/request'

  export default {
    name: 'Boss',
    data() {
      return {
        size: '1',
        cardDetail: {},
        dataTime:[]
      }
    },
    computed: {},
    created() {

    },
    mounted() {
      this.dataTime = [moment().startOf('day').subtract(1, 'weeks').format('YYYY-MM-DD'),moment().format('YYYY-MM-DD')]
      this.getcardlist()
      this.drawChart()
      this.teamChart()
      this.comscholl()
      // this.getLast()
      this.getdata(this.size)

    },
    methods: {
      moment,
      //  获取第一行接口
      getcardlist() {
        axios
          .get(`/manage/recruitModule/team`)
          .then((res) => {
            this.cardDetail = res.result
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
      // 获取第三行左边
      teamChart() {
        axios
          .get(`/manage/recruitModule/teamTasks`)
          .then((res) => {
            // 基于准备好的dom，初始化echarts实例
            let teamChart = this.$echarts.init(document.getElementById('team'))
            // 指定图表的配置项和数据
            let option = {
              tooltip: {
                trigger: 'axis'
              },
              legend: {
                data: ['收费人数', '退费人数']
              },
              xAxis: [
                {
                  type: 'category',
                  data: res.result.teams
                }
              ],
              yAxis: [
                {
                  type: 'value'
                }
              ],
              series: [
                {
                  name: '收费人数',
                  type: 'bar',
                  data: res.result.TeamChargeCounts
                },
                {
                  name: '退费人数',
                  type: 'bar',
                  data: res.result.TeamRefundCounts
                }
              ]
            }
            // 使用刚指定的配置项和数据显示图表。
            teamChart.setOption(option,true)
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {
          })
      },
      // 获取第三行右边
      comscholl() {
        axios
          .post(`/manage/recruitModule/ReceptionAtSchool`,{
            staTime:moment().startOf('day').subtract(1, 'weeks').format('YYYY-MM-DD'),
            endTime:moment().format('YYYY-MM-DD'),
            // staTime:'2021-05-05',
            // endTime:'2021-05-10',
          })
          .then((res) => {
            let series = []
            let tab = []
            res.result.yAxis.map((item)=>{
              tab.push(item.teacher)
              series.push({
                name: item.teacher,
                type: 'line',
                stack: '总量',
                data: item.count
              })
            })

            let comscholl = this.$echarts.init(document.getElementById('comscholl'))
            let option = {
              title: {},
              tooltip: {
                trigger: 'axis'
              },
              legend: {
                data: tab
              },
              // grid: {
              //   left: '3%',
              //   right: '4%',
              //   bottom: '3%',
              //   containLabel: true
              // },
              // toolbox: {
              //   feature: {
              //     saveAsImage: {}
              //   }
              // },
              xAxis: {
                type: 'category',
                boundaryGap: false,
                // data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
                data: res.result.xAxis
              },
              yAxis: {
                type: 'value'
              },
              series: series
            }
            comscholl.setOption(option,true)
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {
          })
      },
      onChangeThreeRight(dates, dateStrings) {
        axios
          .post(`/manage/recruitModule/ReceptionAtSchool`,{
            staTime:dateStrings[0],
            endTime:dateStrings[1],
          })
          .then((res) => {
            let series = []
            let tab = []
            res.result.yAxis.map((item)=>{
              tab.push(item.teacher)
              series.push({
                name: item.teacher,
                type: 'line',
                stack: '总量',
                data: item.count
              })
            })

            let comscholl = this.$echarts.init(document.getElementById('comscholl'))
            let option = {
              title: {},
              tooltip: {
                trigger: 'axis'
              },
              legend: {
                data: tab
              },
              // grid: {
              //   left: '3%',
              //   right: '4%',
              //   bottom: '3%',
              //   containLabel: true
              // },
              // toolbox: {
              //   feature: {
              //     saveAsImage: {}
              //   }
              // },
              xAxis: {
                type: 'category',
                boundaryGap: false,
                // data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
                data: res.result.xAxis
              },
              yAxis: {
                type: 'value'
              },
              series: series
            }
            comscholl.setOption(option,true)
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {
          })
      },
      //  获取最后一行
      getLast(){
        axios
          .post(`/manage/recruitModule/TeamTrend`,{
            staTime:moment().startOf('day').subtract(1, 'weeks').format('YYYY-MM-DD'),
            endTime:moment().format('YYYY-MM-DD'),
            type:this.size
          })
          .then((res) => {
            let pieData = []
            if(res.result.PieChart.data && res.result.PieChart.data.length>0){
              res.result.PieChart.data.map((item)=>{
                pieData.push({
                  value: item.num,
                  name: item.name
                })
              })
            }
            let pie = this.$echarts.init(document.getElementById('pie'))
            let pieOption = {
              tooltip: {
                trigger: 'item'
              },
              legend: {
                top: '5%',
                left: 'center'
              },
              series: [
                {
                  name: '',
                  type: 'pie',
                  radius: ['40%', '70%'],
                  avoidLabelOverlap: false,
                  label: {
                    show: false,
                    position: 'center'
                  },
                  emphasis: {
                    label: {
                      show: true,
                      fontSize: '40',
                      fontWeight: 'bold'
                    }
                  },
                  labelLine: {
                    show: false
                  },
                  data: pieData
                }
              ]
            }
            pie.setOption(pieOption,true)

            let series = []
            let tab = []
            if(res.result.LineChart.LineCharts && res.result.LineChart.LineCharts.length>0){
              res.result.LineChart.LineCharts.map((item)=>{
                tab.push(item.TabName)
                series.push({
                  name: item.TabName,
                  type: 'line',
                  stack: '总量',
                  data: item.num
                })
              })
            }


            let trend = this.$echarts.init(document.getElementById('trend'))
            let lineOption = {
              title: {},
              tooltip: {
                trigger: 'axis'
              },
              legend: {
                data: tab
              },
              // grid: {
              //   left: '3%',
              //   right: '4%',
              //   bottom: '3%',
              //   containLabel: true
              // },
              // toolbox: {
              //   feature: {
              //     saveAsImage: {}
              //   }
              // },
              xAxis: {
                type: 'category',
                boundaryGap: false,
                data: res.result.LineChart.xAxis
              },
              yAxis: {
                type: 'value'
              },
              series: series
            }
            trend.setOption(lineOption,true)
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {
          })
      },
      onChange(dates, dateStrings) {
        console.log('onChange')
        this.dataTime = [dateStrings[0],dateStrings[1]]
        this.getdata(this.size)

      },
      getdata(size){
        axios
          .post(`/manage/recruitModule/TeamTrend`,{
            staTime:this.dataTime[0],
            endTime:this.dataTime[1],
            type:size
          })
          .then((res) => {
            let pieData = []
            if(res.result.PieChart.data && res.result.PieChart.data.length>0){
              res.result.PieChart.data.map((item)=>{
                pieData.push({
                  value: item.num,
                  name: item.name
                })
              })
            }
            let pie = this.$echarts.init(document.getElementById('pie'))
            let pieOption = {
              tooltip: {
                trigger: 'item'
              },
              legend: {
                top: '5%',
                left: 'center'
              },
              series: [
                {
                  name: '',
                  type: 'pie',
                  radius: ['40%', '70%'],
                  avoidLabelOverlap: false,
                  label: {
                    show: false,
                    position: 'center'
                  },
                  emphasis: {
                    label: {
                      show: true,
                      fontSize: '40',
                      fontWeight: 'bold'
                    }
                  },
                  labelLine: {
                    show: false
                  },
                  data: pieData
                }
              ]
            }
            pie.setOption(pieOption,true)

            let series = []
            let tab = []
            if(res.result.LineChart.LineCharts && res.result.LineChart.LineCharts.length>0){
              res.result.LineChart.LineCharts.map((item)=>{
                tab.push(item.TabName)
                series.push({
                  name: item.TabName,
                  type: 'line',
                  stack: '总量',
                  data: item.num
                })
              })
            }
            this.updataline(res,series,tab)
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {
          })
      },
      updataline(res,series,tab){
        let trend = this.$echarts.init(document.getElementById('trend'))
        console.log(series)
        console.log(tab)
        let lineOption = {
          title: {},
          tooltip: {
            trigger: 'axis'
          },
          legend: {
            data: tab
          },
          // grid: {
          //   left: '3%',
          //   right: '4%',
          //   bottom: '3%',
          //   containLabel: true
          // },
          // toolbox: {
          //   feature: {
          //     saveAsImage: {}
          //   }
          // },
          xAxis: {
            type: 'category',
            boundaryGap: false,
            data: res.result.LineChart.xAxis
          },
          yAxis: {
            type: 'value'
          },
          series: series
        }
        trend.setOption(lineOption, true)
      },
      onChangeButton(size) {
        this.getdata(size)

      },
    }
  }
</script>
<style lang="less" scoped>
  .boss {
    .first-row,
    .three-row {
      display: flex;

      > div {
        width: 50%;

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