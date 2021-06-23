<template>
  <div>
    <Propaganda v-if="indexStyle==0"></Propaganda>
<!--    <boss v-if="indexStyle==0"></boss>-->
<!--    <index-chart v-if="indexStyle==1"></index-chart>-->
<!--    <index-bdc v-if="indexStyle==2"></index-bdc>-->
<!--    <index-task v-if="indexStyle==3"></index-task>-->
<!--    <div style="width: 100%;text-align: right;margin-top: 20px">-->
<!--      请选择首页样式：-->
<!--      <a-radio-group v-model="indexStyle">-->
<!--        <a-radio :value="0">默认列表</a-radio>-->
<!--        <a-radio :value="1">统计图表</a-radio>-->
<!--        <a-radio :value="2">统计图表2</a-radio>-->
<!--        <a-radio :value="3">任务表格</a-radio>-->
<!--      </a-radio-group>-->
<!--    </div>-->
    <a-modal width="900px" :visible="show" :footer="null" @cancel="handleCancel">
      <a-row v-if="indexStyle === 0">
        <a-col :span="24">
          <a-card :loading="loading" :bordered="false" title="操作指引(请按操作指引顺序操作)"  >
            <div style="display:flex;justify-content: space-between;">
              <a-steps :current="Number(showII)" size="small" >
                <a-step v-for="(item,index) in guide" :key="index" style="cursor: pointer"  :status="item.type === 'true' ? 'finish' : 'wait'">
                  <template slot="title" >
                    <icon-font :type="item.logo" style="font-size: 3em;margin-left: 0.5rem" @click="go(item)"></icon-font>
                  </template>
                  <template slot="description" >
                    <span @click="go(item)">{{item.value}}</span>
                  </template>
                </a-step>
              </a-steps>
            </div>
          </a-card>
        </a-col>
      </a-row>
    </a-modal>
  </div>
</template>

<script>
  import IndexChart from './IndexChart'
  import IndexTask from "./IndexTask"
  import IndexBdc from './IndexBdc'
  import Boss from '../report/boss'
  import Propaganda from '../report/propaganda'
  import { axios } from '@/utils/request'

  import { Icon } from 'ant-design-vue';

  const IconFont = Icon.createFromIconfontCN({
    scriptUrl: '//at.alicdn.com/t/font_2587092_yiycsbm6al.js',
  });

  export default {
    name: "Analysis",
    components: {
      IndexChart,
      IndexTask,
      IndexBdc,
      IconFont,
      Boss,
      Propaganda
    },
    data() {
      return {
        indexStyle:0,
        showII:'',
        show:false,
        guide:[
          {
            value:'绑定企业微信', //名称
            id:1,
            url:'/RecruitSchoolTenantInfo', // 跳转路径
            logo:'icon-1'  // 图片
          },
          {
            value:'同步通讯录',
            id:2,
            url:'/system/TenantUserList', // 跳转路径
            logo:'icon-2'  // 图片
          },
          {
            value:'配置角色',
            id:3,
            url:'/system/TenantRoleUserList', // 跳转路径
            logo:'icon-4'  // 图片
          },
          {
            value:'配置用户角色',
            id:4,
            url:'/system/TenantUserList', // 跳转路径
            logo:'icon-5'  // 图片
          }],
        loading: true,
      }
    },
    created() {
      this.getAdmin();
    },
    methods: {
      // 获取是平台还是学校端
      getAdmin(){
        axios
          .get(`/manage/recruitSchoolIno/schoolrOrplatform`)
          .then((res) => {
            this.indexStyle = res.result.type === '2' ? 0 : 1  // 0 学校  1 平台
            if(res.result.type === '2'){
              this.getYd();
            }
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {})
      },
      getYd(){
        axios
          .get(`/system/systemUser/judgeadmin?username=${JSON.parse(window.localStorage.getItem('pro__Login_Username')).value}`)
          .then((res) => {
            for (let j = 0; j < res.result.list.length; j++){
              if(res.result.list[j].type === 'false'){
                this.showII = j
                break
              }
            }

            if(res.result.show === '1'){
              this.show = true
              this.loading = false
              for (let i = 0; i < this.guide.length; i++){
                for (let j = 0; j < res.result.list.length; j++){
                  if(this.guide[i].id === res.result.list[j].id){
                    this.guide[i].type = res.result.list[j].type
                  }
                }
              }
            }
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {})
      },
      go(item){
        if(item.id === 2){
          if(this.guide[0].type !== 'true'){
            this.$message.warning('请先绑定企业微信，完成第一步操作');
            return false
          }
        }
        this.$router.push(item.url)
        this.handleCancel()
      },
      handleCancel() {
        this.show = false;
      },
    }
  }
</script>