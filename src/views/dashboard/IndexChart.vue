<template>
  <div class="page-header-index-wide">
<!--    <a-row>-->
<!--      <a-col :span="24">-->
<!--        <a-card v-if="show" :loading="loading" :bordered="false" title="操作指引(请按操作指引顺序操作)"  >-->
<!--          <div style="display:flex;justify-content: space-between;">-->
<!--            <a-steps :current="Number(showII)" size="small" >-->
<!--              <a-step v-for="(item,index) in guide" :key="index" style="cursor: pointer"  :status="item.type === 'true' ? 'finish' : 'wait'">-->
<!--                <template slot="title" >-->
<!--                  <icon-font :type="item.logo" style="font-size: 3em;margin-left: 0.5rem" @click="go(item)"></icon-font>-->
<!--                </template>-->
<!--                <template slot="description" >-->
<!--                  <span @click="go(item)">{{item.value}}</span>-->
<!--                </template>-->
<!--              </a-step>-->
<!--            </a-steps>-->
<!--          </div>-->
<!--        </a-card>-->
<!--      </a-col>-->
<!--    </a-row>-->

<!--    <br>-->
    <a-row :gutter="24">
      <a-col :sm="24" :md="12" :xl="6" :style="{ marginBottom: '24px' }">
        <chart-card :loading="loading" title="总销售额" total="￥126,560">
          <a-tooltip title="指标说明" slot="action">
            <a-icon type="info-circle-o" />
          </a-tooltip>
          <div>
            <trend flag="up" style="margin-right: 16px;">
              <span slot="term">周同比</span>
              12%
            </trend>
            <trend flag="down">
              <span slot="term">日同比</span>
              11%
            </trend>
          </div>
          <template slot="footer">日均销售额<span>￥ 234.56</span></template>
        </chart-card>
      </a-col>
      <a-col :sm="24" :md="12" :xl="6" :style="{ marginBottom: '24px' }">
        <chart-card :loading="loading" title="订单量" :total="8846 | NumberFormat">
          <a-tooltip title="指标说明" slot="action">
            <a-icon type="info-circle-o" />
          </a-tooltip>
          <div>
            <mini-area />
          </div>
          <template slot="footer">日订单量<span> {{ '1234' | NumberFormat }}</span></template>
        </chart-card>
      </a-col>
      <a-col :sm="24" :md="12" :xl="6" :style="{ marginBottom: '24px' }">
        <chart-card :loading="loading" title="支付笔数" :total="6560 | NumberFormat">
          <a-tooltip title="指标说明" slot="action">
            <a-icon type="info-circle-o" />
          </a-tooltip>
          <div>
            <mini-bar :height="40" />
          </div>
          <template slot="footer">转化率 <span>60%</span></template>
        </chart-card>
      </a-col>
      <a-col :sm="24" :md="12" :xl="6" :style="{ marginBottom: '24px' }">
        <chart-card :loading="loading" title="运营活动效果" total="78%">
          <a-tooltip title="指标说明" slot="action">
            <a-icon type="info-circle-o" />
          </a-tooltip>
          <div>
            <mini-progress color="rgb(19, 194, 194)" :target="80" :percentage="78" :height="8" />
          </div>
          <template slot="footer">
            <trend flag="down" style="margin-right: 16px;">
              <span slot="term">同周比</span>
              12%
            </trend>
            <trend flag="up">
              <span slot="term">日环比</span>
              80%
            </trend>
          </template>
        </chart-card>
      </a-col>
    </a-row>

    <a-card :loading="loading" :bordered="false" :body-style="{padding: '0'}">
      <div class="salesCard">
        <a-tabs default-active-key="1" size="large" :tab-bar-style="{marginBottom: '24px', paddingLeft: '16px'}">
          <div class="extra-wrapper" slot="tabBarExtraContent">
            <div class="extra-item">
              <a>今日</a>
              <a>本周</a>
              <a>本月</a>
              <a>本年</a>
            </div>
            <a-range-picker :style="{width: '256px'}" />
          </div>
          <a-tab-pane loading="true" tab="销售额" key="1">
            <a-row>
              <a-col :xl="16" :lg="12" :md="12" :sm="24" :xs="24">
                <bar title="销售额排行" :dataSource="barData"/>
              </a-col>
              <a-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
                <rank-list title="门店销售排行榜" :list="rankList"/>
              </a-col>
            </a-row>
          </a-tab-pane>
          <a-tab-pane tab="销售趋势" key="2">
            <a-row>
              <a-col :xl="16" :lg="12" :md="12" :sm="24" :xs="24">
                <bar title="销售额趋势" :dataSource="barData"/>
              </a-col>
              <a-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
                <rank-list title="门店销售排行榜" :list="rankList"/>
              </a-col>
            </a-row>
          </a-tab-pane>
        </a-tabs>
      </div>
    </a-card>

    <a-row>
      <a-col :span="24">
        <a-card :loading="loading" :bordered="false" title="最近一周访问量统计" :style="{ marginTop: '24px' }">
          <a-row>
            <a-col :span="6">
              <head-info title="今日IP" :content="loginfo.todayIp"></head-info>
            </a-col>
            <a-col :span="2">
              <a-spin class='circle-cust'>
                <a-icon slot="indicator" type="environment" style="font-size: 24px"  />
              </a-spin>
            </a-col>
            <a-col :span="6">
              <head-info title="今日访问" :content="loginfo.todayVisitCount"></head-info>
            </a-col>
            <a-col :span="2">
              <a-spin class='circle-cust'>
                <a-icon slot="indicator" type="team" style="font-size: 24px"  />
              </a-spin>
            </a-col>
            <a-col :span="6">
              <head-info title="总访问量" :content="loginfo.totalVisitCount"></head-info>
            </a-col>
            <a-col :span="2">
              <a-spin class='circle-cust'>
                <a-icon slot="indicator" type="rise" style="font-size: 24px"  />
              </a-spin>
            </a-col>
          </a-row>
          <line-chart-multid :fields="visitFields" :dataSource="visitInfo"></line-chart-multid>
        </a-card>
      </a-col>
    </a-row>
  </div>
</template>

<script>
  import ChartCard from '@/components/ChartCard'
  import ACol from "ant-design-vue/es/grid/Col"
  import ATooltip from "ant-design-vue/es/tooltip/Tooltip"
  import MiniArea from '@/components/chart/MiniArea'
  import MiniBar from '@/components/chart/MiniBar'
  import MiniProgress from '@/components/chart/MiniProgress'
  import RankList from '@/components/chart/RankList'
  import Bar from '@/components/chart/Bar'
  import LineChartMultid from '@/components/chart/LineChartMultid'
  import HeadInfo from '@/components/tools/HeadInfo.vue'
  import Trend from '@/components/Trend'
  import { getLoginfo,getVisitInfo } from '@/api/api'
  import { axios } from '@/utils/request'
  import one  from '../../assets/yd/1.svg'
  import two  from '../../assets/yd/2.svg'
  import three  from '../../assets/yd/3.svg'
  import fore  from '../../assets/yd/4.svg'
  import five  from '../../assets/yd/5.svg'

  import { Icon } from 'ant-design-vue';

  const IconFont = Icon.createFromIconfontCN({
    scriptUrl: '//at.alicdn.com/t/font_2587092_yiycsbm6al.js',
  });

  const rankList = []
  for (let i = 0; i < 7; i++) {
    rankList.push({
      name: '白鹭岛 ' + (i+1) + ' 号店',
      total: 1234.56 - i * 100
    })
  }
  const barData = []
  for (let i = 0; i < 12; i += 1) {
    barData.push({
      x: `${i + 1}月`,
      y: Math.floor(Math.random() * 1000) + 200
    })
  }
  export default {
    name: "IndexChart",
    components: {
      ATooltip,
      ACol,
      ChartCard,
      MiniArea,
      MiniBar,
      MiniProgress,
      RankList,
      Bar,
      Trend,
      LineChartMultid,
      IconFont,
      HeadInfo
    },

    data() {
      return {
        loading: true,
        center: null,
        rankList,
        barData,
        loginfo:{},
        show:false,
        guide:[
          {
            value:'绑定企业微信', //名称
            id:1,
            url:'/RecruitSchoolTenantInfo', // 跳转路径
            logo:'icon-1'  // 图片
          },
          {
            value:'同步部门信息',
            id:2,
            url:'/system/TenantDepartList', // 跳转路径
            logo:'icon-2'  // 图片
          },
          {
            value:'同步用户信息',
            id:3,
            url:'/system/TenantUserList', // 跳转路径
            logo:'icon-3'  // 图片
          },
          {
            value:'配置角色',
            id:4,
            url:'/system/TenantRoleUserList', // 跳转路径
            logo:'icon-4'  // 图片
          },
          {
            value:'配置用户角色',
            id:5,
            url:'/system/TenantUserList', // 跳转路径
            logo:'icon-5'  // 图片
          }],
        visitFields:['ip','visit'],
        visitInfo:[],
        showII:''
    }
    },
    created() {
      setTimeout(() => {
        this.loading = !this.loading
      }, 1000)
      this.initLogInfo();
      // this.getYd();
    },
    methods: {
      initLogInfo () {
        getLoginfo(null).then((res)=>{
          if(res.success){
            Object.keys(res.result).forEach(key=>{
              res.result[key] =res.result[key]+""
            })
            this.loginfo = res.result;
          }
        })
        getVisitInfo().then(res=>{
          if(res.success){
            this.visitInfo = res.result;
          }
        })
      },
      go(item){
        console.log(item)
        if(item.id === 2){
          if(this.guide[0].type !== 'true'){
            this.$message.warning('请先绑定企业微信，完成第一步操作');
            return false
          }
        }
        this.$router.push(item.url)
      },
      getYd(){
        axios
          .get(`/system/systemUser/judgeadmin?username=${JSON.parse(window.localStorage.getItem('pro__Login_Username')).value}`)
          .then((res) => {
            console.log(res,876)

            for (let j = 0; j < res.result.list.length; j++){
              if(res.result.list[j].type === 'false'){
                this.showII = j
                break
              }
            }

            if(res.result.show === '1'){
              this.show = true
              for (let i = 0; i < this.guide.length; i++){
                for (let j = 0; j < res.result.list.length; j++){
                  if(this.guide[i].id === res.result.list[j].id){
                    this.guide[i].type = res.result.list[j].type
                  }
                }
              }
              console.log(this.guide)
            }
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {})
      },
    }
  }
</script>

<style lang="less" scoped>
  .circle-cust{
    position: relative;
    top: 28px;
    left: -100%;
  }
  .extra-wrapper {
    line-height: 55px;
    padding-right: 24px;

    .extra-item {
      display: inline-block;
      margin-right: 24px;

      a {
        margin-left: 24px;
      }
    }
  }

  /* 首页访问量统计 */
  .head-info {
    position: relative;
    text-align: left;
    padding: 0 32px 0 0;
    min-width: 125px;

    &.center {
      text-align: center;
      padding: 0 32px;
    }

    span {
      color: rgba(0, 0, 0, .45);
      display: inline-block;
      font-size: .95rem;
      line-height: 42px;
      margin-bottom: 4px;
    }
    p {
      line-height: 42px;
      margin: 0;
      a {
        font-weight: 600;
        font-size: 1rem;
      }
    }
  }
</style>