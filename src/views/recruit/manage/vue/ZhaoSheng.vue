<template>
  <div class="app-container">
    <div  class="main">
        <div class="header">
            <div class="left">
                <!-- <el-date-picker
                    v-model="time"
                    type="daterange"
                    clearable
                    style="width: 400px;"
                    size="small"
                    range-separator="至"
                    start-placeholder="开始日期"
                    end-placeholder="结束日期"
                    value-format="yyyy-MM-dd"
                    @change="handleSearchTotal"
                >
                </el-date-picker> -->
            </div>
            <div v-cloak class="center">
                {{ time && time[0] && time[1] ? `${time[0]} - ${time[1]}` : '' }}
            </div>
        </div>
        <div v-loading="loading" class="content">
            <a-row :gutter="20" type="flex" justify="center" align="center">
                <a-col  class="statistic-box">
                    <a-card title="新增用户数 " class="box-card" style="width: 400px" @click="NumberOfNewUsers(0)">
                      <div slot="extra" href="#">单位：(人)</div>
                      <div class="number">{{ totalUsersNum || 0 }}</div>
                    </a-card>
                </a-col>
                <a-col  class="statistic-box">
                    <a-card title="被动联系数 " class="box-card" style="width: 400px" @click="NumberOfNewUsers(1)">
                      <div slot="extra" href="#">单位：(人)</div>
                      <div class="number">{{ totalAmount || 0}}</div>
                    </a-card>
                </a-col>
                <a-col  class="statistic-box">
                    <a-card title="主动联系数 " class="box-card" style="width: 400px" @click="NumberOfNewUsers(2)">
                      <div slot="extra" href="#">单位：(人)</div>
                      <div class="number">{{ totalTopUp || 0}}</div>
                    </a-card>
                </a-col>
            </a-row>
        </div>
    </div>
    <div class="header2">
        <div class="left">
            <a-select @change="dataChange"  v-model="date" style="width: 150px" placeholder="请选择">
                <a-select-option value="最近7天">最近7天</a-select-option>
                <a-select-option value="最近15天">最近15天</a-select-option>
                <a-select-option value="最近30天">最近30天</a-select-option>
            </a-select>
        </div>
        <div v-cloak class="center">
            {{ `${startTime} - ${endTime}（${date}）` }}
        </div>
    </div>
    <div v-loading="loading2" class="year-data">
        <div ref="line" class="line"></div>
    </div>
  </div>
</template>

<script>
import moment from 'moment'
// import E from "wangeditor"
export default {
  name: 'app-container',
    data() {
      return {
          index:'1',
          activeIndex: '1',
          // 分隔线
          loading:false,
          loading2:false,
          activeName:1,
          labelSpan:4,
          expand:false,
          showContent:false,
          bar:null,
          pie:null,
          month:null,
          line:null,
          year:null,
          time:[],
          totalAmount:0,
          totalUsersNum:0,
          totalTopUp:0,
          date:'最近7天',
          startTime:moment().startOf('date').format('YYYY-MM-DD'),
          endTime:moment().endOf('date').format('YYYY-MM-DD'),
          
          lineOptions:{
              legend: {
                  data: ['新增用户数', '被动联系数','主动联系数'],
              },
              grid: {
                  left: '3%',
                  right: '4%',
                  bottom: '3%',
                  containLabel: true
              },
              xAxis: [
                  {
                      type: 'category',
                      boundaryGap: false,
                      data: ['一月', '二月', '三月', '四月', '五月', '六月', '七月','八月','九月','十月','十一月','十二月']
                  }
              ],
              yAxis: [
                  {
                      type: 'value'
                  }
              ],
              series: []
          },
      }
  },
  computed:{
      // ...mapGetters(['userId','roleName','userType']),
      contentSpan(){
          return 24 - this.labelSpan
      },
      showData(){
          // console.log(this.userId,this.roleName,this.userType,)
          // return (!this.userType && this.roleName == '超级管理员') || this.userType == '0'
      },
  },
  mounted(){
      this.initEcharts()
      window.onresize = () => {
          this.resizeEcharts()
      }
      this.dataChange(this.date)
      // this.handleSearchTotal()


      // const editor = new E("#div1")
      // editor.create()
      
  },
  methods: {
            // 分割线
            handleSelect(key, keyPath) {
                this.index=key
                console.log(key, keyPath);
            },
            dataChange(val){
                ({
                    '最近7天':() => {
                        this.startTime = moment().subtract(7-1, 'days').format('YYYY-MM-DD')
                    },
                    '最近15天':() => {
                        this.startTime = moment().subtract(15-1, 'days').format('YYYY-MM-DD')
                    },
                    '最近30天':() => {
                        this.startTime = moment().subtract(30-1, 'days').format('YYYY-MM-DD')
                    }
                })[val]()
                this.handleSearchLine()
            },
            //初始化echarts
            initEcharts(){
                this.line = this.$echarts.init(this.$refs['line'])
                this.line.setOption(this.lineOptions);
            },
            resizeEcharts(){
                this.line.resize()
            },
            // 查询
            handleSearchTotal() {
                this.loading = true
                let params = {  }
                // if(this.userType){
                //     params.userIds = this.userId
                // }
                if(this.time && (this.time[0] == this.time[1])){
                    params.startDate = this.time[0]
                }else if(this.time && this.time[0] && this.time[1]){
                    params.startDate = this.time[0]
                    params.endDate = this.time[1]
                }
                this.totalAmount = 999
                this.totalTopUp = 888
                this.totalUsersNum = 777
                this.loading = false
                // return getTotalData(params).then(({data:{data}})=>{
                  // totalAmount: null
                  // totalTopUp: 580.74
                  // totalUsersNum: 138
                  // this.totalAmount = data.totalAmount
                  // this.totalTopUp = data.totalTopUp
                  // this.totalUsersNum = data.totalUsersNum
                  
                // }).finally(()=>{
                //     this.loading = false
                // })
            },
            //查询折线图
            handleSearchLine(){
                let params = {
                    dateType:this.date,
                }
                // if(this.userType){
                //     params.userIds = this.userId
                // }
                this.loading2 = true
                // return getLineData(params).then(({data:{ data }})=>{
                  let data=[
                    {                  
                    createBy: null,
                    createTime: null,
                    dateType: null,
                    days: 0,
                    developDate: null,
                    endDate: null,
                    startDate: "2021-05-05",
                    totalAmount: 88,
                    totalTopUp: 99,
                    totalUsersNum: 77,
                    updateBy: null,
                    updateTime: null,
                    userId: null,
                    userIds: null},
                    {                  
                    createBy: null,
                    createTime: null,
                    dateType: null,
                    days: 0,
                    developDate: null,
                    endDate: null,
                    startDate: "2021-05-06",
                    totalAmount: 188,
                    totalTopUp: 199,
                    totalUsersNum: 177,
                    updateBy: null,
                    updateTime: null,
                    userId: null,
                    userIds: null},
                    {                  
                    createBy: null,
                    createTime: null,
                    dateType: null,
                    days: 0,
                    developDate: null,
                    endDate: null,
                    startDate: "2021-05-07",
                    totalAmount: 288,
                    totalTopUp: 299,
                    totalUsersNum: 277,
                    updateBy: null,
                    updateTime: null,
                    userId: null,
                    userIds: null},
                    {                  
                    createBy: null,
                    createTime: null,
                    dateType: null,
                    days: 0,
                    developDate: null,
                    endDate: null,
                    startDate: "2021-05-08",
                    totalAmount: 318,
                    totalTopUp: 399,
                    totalUsersNum: 317,
                    updateBy: null,
                    updateTime: null,
                    userId: null,
                    userIds: null},
                    {                  
                    createBy: null,
                    createTime: null,
                    dateType: null,
                    days: 0,
                    developDate: null,
                    endDate: null,
                    startDate: "2021-05-09",
                    totalAmount: 428,
                    totalTopUp: 199,
                    totalUsersNum: 227,
                    updateBy: null,
                    updateTime: null,
                    userId: null,
                    userIds: null},
                    {                  
                    createBy: null,
                    createTime: null,
                    dateType: null,
                    days: 0,
                    developDate: null,
                    endDate: null,
                    startDate: "2021-05-10",
                    totalAmount: 18,
                    totalTopUp: 29,
                    totalUsersNum: 277,
                    updateBy: null,
                    updateTime: null,
                    userId: null,
                    userIds: null},
                    {                  
                    createBy: null,
                    createTime: null,
                    dateType: null,
                    days: 0,
                    developDate: null,
                    endDate: null,
                    startDate: "2021-05-11",
                    totalAmount: 188,
                    totalTopUp: 29,
                    totalUsersNum: 77,
                    updateBy: null,
                    updateTime: null,
                    userId: null,
                    userIds: null},
                  ]

                    this.line.setOption({
                        ...this.lineOptions,
                        xAxis: [
                            {
                                type: 'category',
                                boundaryGap: false,
                                data: data.map(item => item.startDate),
                                // data: 1,
                            }
                        ],
                        series: [
                            {
                                name: '新增用户数',
                                type: 'line',
                                stack: '总量',
                                areaStyle: {},
                                data: data.map(item => item.totalUsersNum || 0),
                                // data: 2,
                            },
                            {
                                name: '被动联系数',
                                type: 'line',
                                stack: '总量',
                                areaStyle: {},
                                data: data.map(item => item.totalAmount || 0),
                                // data: 3,
                            },
                            {
                                name: '主动联系数',
                                type: 'line',
                                stack: '总量',
                                areaStyle: {},
                                data: data.map(item => item.totalTopUp || 0),
                                // data: 4,
                            },
                        ]
                    })
                    this.loading2 = false
                // }).finally(()=>{
                //     this.loading2 = false
                // })
            },
            handleSwitchClick() {
                if(!this.expand){
                    this.expand = true
                    setTimeout(()=>{
                        this.showContent = true
                    },500)
                }else{
                    this.showContent = false
                    this.expand = false
                }
            },
            // 跳转新增用户页面
            NumberOfNewUsers(val){
              if(val==0){
                this.$router.push({
                  path:'/recruit/manage/vue/NumberOfNewUsers'
                })
              }else if(val==1){
                console.log(val)
              }else if(val==2){
                this.$router.push({
                  path:'/recruit/manage/vue/InterestedCandidatesList'
                })
              }
              
            },
        },
 }
</script>

<style lang="less" scoped>
   .d1{
        padding:5px 30px;
        .title{
        .el-menu-demo{
            // margin-left: 20px ;
            padding:0px 20px 0px 20px;
            .menu-item{
            margin: 0 30px;
            }
        }
        }
        .body{
        margin-top:40px;
        }
    }
    .base-info{
        position:relative;
        background:#F0F0F0;
        border-radius:24px;
        box-sizing:border-box;
        transition:all 0.5s linear; 
        .label{
            font-weight:bold;
        }
        .content{
            font-size:14px;
            color:rgba(0,0,0,0.65);
        }
        .row{
            margin: 0 24px;
        }
        .row:not(:first-child){
            margin-top:12px;
        }
        .row:first-child{
            margin-top:24px;
        }
        .row:last-child{
            margin-bottom:24px;
        }
        .switch{
            width:80px;
            height:20px;
            display:flex;
            justify-content: center;
            align-items: center;
            position:absolute;
            left:calc(50% - 40px);
            bottom:-16px;
            background:#F0F0F0;
            border-bottom-left-radius:12px;
            border-bottom-right-radius:12px;
            cursor:pointer;
            z-index:10000;
        }
    }
    .daily-data{
        margin-top:24px;
        .daily-item{
            width:100%;
            padding:24px;
            h4{
                color:rgba(0,0,0,0.65);
            }
            .count{
                font-size:32px;
                margin-top:12px;
            }
            .classifier{
                font-size:16px;
                color:rgba(0,0,0,0.65);
            }

        }
        
    }
    .main{
        .content{
            margin-top:24px;
            .statistic-box{
                .box-card{
                    .number{
                      text-align:right;  
                    }
                    .clearfix{
                        color:rgba(0,0,0,0.65);
                        .left{
                            float:left;
                        }
                        .right{
                            float:right;
                            font-size:12px;
                        }
                    }
                }
            }
        }
    }
    .header2,.main>.header{
        height:36px;
        line-height:36px;
        display:flex;
        justify-content:center;
        align-items:center;
        position:relative;
        &:not(.main>.header){
          margin-top:24px;
        }
        .left{
            position:absolute;
            top:0;
            left:0;
        }
        .center{
            font-size:24px;
            color:rgba(0,0,0,0.65);
            display:inline-block;
            margin:0;
        }
    }
    .year-data{
        margin-top:24px;
        width:100%;
        height:400px;
        .line{
            width:100%;
            height:100%;
        }
        h4{
            color:rgba(0,0,0,0.65);
            margin-bottom:12px;
            text-align:center;
        }
        margin-bottom:24px;
    }
</style>