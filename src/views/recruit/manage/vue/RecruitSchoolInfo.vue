<!--学校介绍-->
<template>
  <div>
    <a-card :bordered="false">
      <detail-list title="展示内容" >
        <a-row type="flex">
          <a-col :flex="5">
            <detail-list-item term="标 题" style="float: none;margin-left: 20px;width: 50%;">
              <a-input style="width: 70%;margin-left: 2rem" v-model="detail.siTitle" :maxLength="20"></a-input>
            </detail-list-item>
            <detail-list-item term="内 容" style="float: none;margin-left: 20px;width: 80%;">
              <j-editor v-model="htm" style="width: 100%;margin-left: 30px;" />
              <!--          <a-input style="width: 70%;margin-left: 2rem" v-model="detail.siTitle"></a-input>-->
            </detail-list-item>
          </a-col>
          <a-col :flex="2">
            <div style="border: 1px solid black;width: 414px;height: 600px;position: relative;">
              <img  style="width: 100%" src="../../../../assets/mob.png"/>
              <div class="aa" style="position: absolute;top: 79px;bottom: 0;overflow: auto;width: 410px;padding: 5px 20px;">

              </div>
            </div>
          </a-col>
        </a-row>
      </detail-list>
      <div style="width: 100%">
        <a-button style="margin-left: 40%" type="primary" @click="serverQuery" >保存</a-button>
        <a-button type="primary" @click="goback"  style="margin-left: 8px">关闭</a-button>
      </div>

    </a-card>

    <a-modal :visible="previewVisible" :footer="null" @cancel="handleCancel()">
      <img alt="example" style="width: 100%" :src="src"/>
    </a-modal>
  </div>
</template>

<script>
  import PageLayout from '@/components/page/PageLayout'
  import STable from '@/components/table/'
  import DetailList from '@/components/tools/DetailList'
  import ABadge from "ant-design-vue/es/badge/Badge"
  const DetailListItem = DetailList.Item
  import { axios } from '@/utils/request'
  import { ACCESS_TOKEN } from "@/store/mutation-types"
  export default {
    components: {
      PageLayout,
      ABadge,
      DetailList,
      DetailListItem,
      STable
    },
    watch: {
      htm: {
        handler(newName) {
          console.log(newName)
          let a = newName
          document.getElementsByClassName('aa')[0].innerHTML = a
        },
      }
    },
    data () {
      return {
        ddd:false,
        uploadAction:window._CONFIG['domianURL']+"/sys/common/upload",
        preview:window._CONFIG['domianURL']+"/sys/common/static/",
        headers:{
          'X-Access-Token' : this.$ls.get(ACCESS_TOKEN)
        },
        goodsColumns: [
          {
            title: '商品编号',
            dataIndex: 'id',
            key: 'id'
          },
          {
            title: '商品名称',
            dataIndex: 'name',
            key: 'name'
          },
          {
            title: '商品条码',
            dataIndex: 'barcode',
            key: 'barcode'
          },
          {
            title: '单价',
            dataIndex: 'price',
            key: 'price',
            align: 'right'
          },
          {
            title: '数量（件）',
            dataIndex: 'num',
            key: 'num',
            align: 'right'
          },
          {
            title: '金额',
            dataIndex: 'amount',
            key: 'amount',
            align: 'right'
          }
        ],
        // 加载数据方法 必须为 Promise 对象
        loadGoodsData: () => {
          return new Promise((resolve => {
            resolve({
              data: [
                {
                  id: '1234561',
                  name: '矿泉水 550ml',
                  barcode: '12421432143214321',
                  price: '2.00',
                  num: '1',
                  amount: '2.00'
                },
                {
                  id: '1234562',
                  name: '凉茶 300ml',
                  barcode: '12421432143214322',
                  price: '3.00',
                  num: '2',
                  amount: '6.00'
                },
                {
                  id: '1234563',
                  name: '好吃的薯片',
                  barcode: '12421432143214323',
                  price: '7.00',
                  num: '4',
                  amount: '28.00'
                },
                {
                  id: '1234564',
                  name: '特别好吃的蛋卷',
                  barcode: '12421432143214324',
                  price: '8.50',
                  num: '3',
                  amount: '25.50'
                }
              ],
              pageSize: 10,
              pageNo: 1,
              totalPage: 1,
              totalCount: 10
            })
          })).then(res => {
            return res
          })
        },

        scheduleColumns: [
          {
            title: '时间',
            dataIndex: 'time',
            key: 'time'
          },
          {
            title: '当前进度',
            dataIndex: 'rate',
            key: 'rate'
          },
          {
            title: '状态',
            dataIndex: 'status',
            key: 'status',
            scopedSlots: { customRender: 'status' },
          },
          {
            title: '操作员ID',
            dataIndex: 'operator',
            key: 'operator'
          },
          {
            title: '耗时',
            dataIndex: 'cost',
            key: 'cost'
          }
        ],
        loadScheduleData: () => {
          return new Promise((resolve => {
            resolve({
              data: [
                {
                  key: '1',
                  time: '2017-10-01 14:10',
                  rate: '联系客户',
                  status: 'processing',
                  operator: '取货员 ID1234',
                  cost: '5mins'
                },
                {
                  key: '2',
                  time: '2017-10-01 14:05',
                  rate: '取货员出发',
                  status: 'success',
                  operator: '取货员 ID1234',
                  cost: '1h'
                },
                {
                  key: '3',
                  time: '2017-10-01 13:05',
                  rate: '取货员接单',
                  status: 'success',
                  operator: '取货员 ID1234',
                  cost: '5mins'
                },
                {
                  key: '4',
                  time: '2017-10-01 13:00',
                  rate: '申请审批通过',
                  status: 'success',
                  operator: '系统',
                  cost: '1h'
                },
                {
                  key: '5',
                  time: '2017-10-01 12:00',
                  rate: '发起退货申请',
                  status: 'success',
                  operator: '用户',
                  cost: '5mins'
                }
              ],
              pageSize: 10,
              pageNo: 1,
              totalPage: 1,
              totalCount: 10
            })
          })).then(res => {
            return res
          })
        },
        fileList: [
          // {
          //   uid: '-1',
          //   name: 'xxx.png',
          //   status: 'done',
          //   url: 'a.jpg',
          //   thumbUrl: `${window._CONFIG['domianURL']+"/sys/common/static/20210520154613_62jpg"}`,
          // },
        ],
        previewVisible:false,
        src:'',
        detail:{
          "siTitle": "",   //---标题
          "id": "",   //---模块id
        },
        htm:''
      }
    },
    filters: {
      statusFilter(status) {
        const statusMap = {
          'processing': '进行中',
          'success': '完成',
          'failed': '失败'
        }
        return statusMap[status]
      }
    },
    computed: {
      title () {
        return this.$route.meta.title
      }
    },
    created(){
      this.getDetail()
    },
    methods:{
      handleRemove(info) {
        console.log(info,99999)
        axios
          .post(`/manage/recruitModule/deletePicOrvideor`,{
            url:info.file.name
          })
          .then((res) => {
            console.log(res,1111111)
            console.log(this.fileList,2222)
            this.fileList = [...info.fileList]
            // this.list = res.result
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {})
        // const index = this.fileList.indexOf(file);
        // const newFileList = this.fileList.slice();
        // newFileList.splice(index, 1);
        // this.fileList = newFileList;
      },
      getDetail(){
        const a = []
        // this.$nextTick(() => {
        axios
          .get(`/manage/recruitSchoolIno/getSchoolInfoDetail/${this.$route.query.moduleId}`)
          .then((res) => {
            this.detail = res.result
            this.htm = JSON.parse(res.result.siContent)
            this.detail = {
              "siTitle": res.result.siTitle,   //---标题
              "siContent": res.result.siContent,   //---简介内容
              "id": res.result.id,   //---模块id
            }

            this.ddd = true
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {})
        // })
      },
      serverQuery(){
        console.log(this.htm)
        axios
          .put(`/manage/recruitSchoolIno/updateRecruitSchoolIno`,{
            "siTitle": this.detail.siTitle,   //---标题
            "siContent": this.htm,   //---简介内容
            "id": this.detail.id,   //---模块id
          })
          .then((res) => {
            console.log(res)
            if(res.result === '修改成功'){
              this.$message.success(res.result);
            }

            // this.list = res.result
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {})
      },
      goback(){
        this.$router.push({name: 'manage-recruitModule'});
      },
      onblur(){
        console.log(this.detail)
      }
    }

  }
</script>

<style lang="less" scoped>
  .title {
    color: rgba(0,0,0,.85);
    font-size: 16px;
    font-weight: 500;
    margin-bottom: 16px;
  }
</style>

<!--<style scoped>-->
<!--  /* tile uploaded pictures */-->
<!--  .upload-list-inline >>> .ant-upload-list-item {-->
<!--    float: left;-->
<!--    width: 200px;-->
<!--    margin-right: 8px;-->
<!--  }-->
<!--  .upload-list-inline >>> .ant-upload-animate-enter {-->
<!--    animation-name: uploadAnimateInlineIn;-->
<!--  }-->
<!--  .upload-list-inline >>> .ant-upload-animate-leave {-->
<!--    animation-name: uploadAnimateInlineOut;-->
<!--  }-->
<!--</style>-->