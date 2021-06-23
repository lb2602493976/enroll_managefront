<!--团队贡献-->
<template>
  <div class="boss">
    <!-- 第一行 -->
    <div class="first-row">
      <h2>全部团队</h2>
      <div id="main" style="width: 1800px; height: 400px"></div>
    </div>
    <!-- 第二行 -->
    <h2>团队贡献明细</h2>
    <a-table :columns="columns" rowKey="id" :data-source="data" :pagination="pagination" @change="change">
    </a-table>
  </div>
</template>

<script>
import moment from 'moment'
import { axios } from '@/utils/request'

export default {
  name: 'Boss',
  computed: {},
  data() {
    return {
      columns: [
        {
          title: '序号',
          dataIndex: 'index',
          key: 'index',
          align: 'center',
          width: 50,
          customRender: (text,record,index) => `${index+1}`,
        },
        {
          title: '姓名',
          dataIndex: 'realname',
          align: 'center',
          key: 'realname',
        },
        {
          title: '团队名称',
          dataIndex: 'depart_name',
          align: 'center',
          key: 'depart_name',
        },
        {
          title: '职位',
          key: 'if_depart_principal',
          dataIndex: 'if_depart_principal',
          align: 'center',
        },
        {
          title: '电话',
          key: 'phone',
          dataIndex: 'phone',
          align: 'center',

        },
        {
          title: '报名缴费人数',
          key: 'Recruit',
          dataIndex: 'Recruit',
          align: 'center',
        },
        {
          title: '报名贡献值占比',
          key: 'Recruitpercentage',
          dataIndex: 'Recruitpercentage',
          align: 'center',
        },
        {
          title: '退费人数',
          key: 'Refund',
          dataIndex: 'Refund',
          align: 'center',
        },
        {
          title: '退费人数占比',
          key: 'Refunpercentage',
          dataIndex: 'Refunpercentage',
          align: 'center',
        },
      ],
      data: [],
      pagination: {
        current: 1,
        pageSize: 10,
        total: 0,
      },
      majorId:'',
      list:[]
    }
  },
  created() {},
  mounted() {
    this.teamChart()
    this.getList()
  },
  methods: {
    moment,
    onChange(dates, dateStrings) {
      console.log('From: ', dates[0], ', to: ', dates[1])
      console.log('From: ', dateStrings[0], ', to: ', dateStrings[1])
    },
    drawChart(pa) {
      const _this = this
      // 基于准备好的dom，初始化echarts实例
      let myChart = this.$echarts.init(document.getElementById('main'))
      // 指定图表的配置项和数据
      let option = {
        tooltip: {
          trigger: 'axis',
        },
        legend: {
          data: ['缴费人数', '退费人数'],
        },
        xAxis: [
          {
            type: 'category',
            data: pa.data1,
          },
        ],
        yAxis: [
          {
            type: 'value',
          },
        ],
        series: [
          {
            name: '缴费人数',
            type: 'bar',
            barGap: 0,
            data: pa.data2,
          },
          {
            name: '退费人数',
            type: 'bar',
            data: pa.data3,
          },
        ],
      }
      // 使用刚指定的配置项和数据显示图表。
      myChart.setOption(option)

      myChart.on('click', function (params) {
        _this.majorId = _this.list.filter(item => item.teanName === params.name)[0].teamId
        _this.getList()
      })
    },
    // 获取图标数据
    teamChart(){
      let data1 = [] // 团队
      let data2 = [] // 缴费
      let data3 = [] // 退费
      axios
        .get('/manage/recruitModule/teamTasks')
        .then((res) => {
          console.log(res,9988877)
          this.list = res.result
          res.result.map((item)=>{
            data1.push(item.teanName)
            data2.push(item.TeamChargeCount)
            data3.push(item.TeamRefundCount)
            const pa = {
              data1: data1,
              data2: [10,30],
              data3: [23,56],
            }
            this.drawChart(pa)
          })
        })
        .catch((err) => {
          console.log(err)
        })
        .finally(() => {})


    },
    // 获取列表
    getList(){
      axios
        .post('/manage/recruitModule/contributiondetails', {
          "majorId":this.majorId,
          "pageNum":this.pagination.current.toString(),
          "pageSize":this.pagination.pageSize.toString()
        })
        .then((res) => {
          // console.log(res,99888)
          this.data = res.result.pageList
          this.pagination.total = res.result.total
          // if (res.success) {
          //   this.loadData(1)
          // }
        })
        .catch((err) => {
          console.log(err)
        })
        .finally(() => {})
    },
    // 改变页面获取列表
    change(parms){
      this.pagination.current = parms.current
      axios
        .post('/manage/recruitModule/contributiondetails', {
          "majorId":this.majorId,
          "pageNum":parms.current.toString(),
          "pageSize":parms.pageSize.toString()
        })
        .then((res) => {
          this.data = res.result.pageList
        })
        .catch((err) => {
          console.log(err)
        })
        .finally(() => {})
    }
  },
}
</script>
<style lang="less" scoped>
.editable-row-operations a {
  margin-right: 8px;
}
</style>