<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="姓名">
              <a-input placeholder="请输入姓名" v-model="queryParam.realname"></a-input>
            </a-form-item>
          </a-col>
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="手机号">
              <a-input placeholder="请输入手机号" v-model="queryParam.phone"></a-input>
            </a-form-item>
          </a-col>
          <!-- <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="招生团队">
              <j-dict-select-tag
                placeholder="请选择招生团队"
                v-model="queryParam.orgCode"
                dictCode="sys_depart,depart_name,org_code"
              />
            </a-form-item>
          </a-col> -->
          <!-- <template v-if="toggleSearchStatus">
            
          </template> -->
          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <span style="float: left; overflow: hidden" class="table-page-search-submitButtons">
              <a-button type="primary" @click="searchQuery" icon="search">查询</a-button>
              <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>
              <!-- <a @click="handleToggleSearch" style="margin-left: 8px">
                {{ toggleSearchStatus ? '收起' : '展开' }}
                <a-icon :type="toggleSearchStatus ? 'up' : 'down'"/>
              </a> -->
            </span>
          </a-col>
        </a-row>
      </a-form>
    </div>
    <!-- 查询区域-END -->

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <a-button @click="handleAdd" type="primary" icon="plus">添加人员</a-button>
      <!-- <a-button type="primary" icon="download" @click="handleExportXls('sys_user')">导出</a-button>
      <a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">
        <a-button type="primary" icon="import">导入</a-button>
      </a-upload> -->
      <!-- 高级查询区域 -->
      <!-- <j-super-query :fieldList="superFieldList" ref="superQueryModal" @handleSuperQuery="handleSuperQuery"></j-super-query> -->
      <!-- <a-dropdown v-if="selectedRowKeys.length > 0">
        <a-menu slot="overlay">
          <a-menu-item key="1" @click="batchDel"><a-icon type="delete" />删除</a-menu-item>
          <a-menu-item key="1" @click="setReceptionist()"><a-icon type="user" />设置接待</a-menu-item>
          <a-menu-item key="1" @click="showModal()"><a-icon type="team" />设置团队</a-menu-item>
        </a-menu>
        <a-button style="margin-left: 8px"> 批量操作 <a-icon type="down" /></a-button>
      </a-dropdown> -->
    </div>

    <!-- table区域-begin -->
    <div>
      <!-- <div class="ant-alert ant-alert-info" style="margin-bottom: 16px">
        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择
        <a style="font-weight: 600">{{ selectedRowKeys.length }}</a
        >项
        <a style="margin-left: 24px" @click="onClearSelected">清空</a>
      </div> -->

      <a-table
        ref="table"
        size="middle"
        :scroll="{ x: true }"
        bordered
        rowKey="id"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        class="j-table-force-nowrap"
        @change="handleTableChange"
      >
        <template slot="htmlSlot" slot-scope="text">
          <div v-html="text"></div>
        </template>
        <template slot="imgSlot" slot-scope="text">
          <span v-if="!text" style="font-size: 12px; font-style: italic">无图片</span>
          <img
            v-else
            :src="getImgView(text)"
            height="25px"
            alt=""
            style="max-width: 80px; font-size: 12px; font-style: italic"
          />
        </template>
        <template slot="fileSlot" slot-scope="text">
          <span v-if="!text" style="font-size: 12px; font-style: italic">无文件</span>
          <a-button v-else :ghost="true" type="primary" icon="download" size="small" @click="downloadFile(text)">
            下载
          </a-button>
        </template>

        <span slot="action" slot-scope="text, record">
          <a @click="setDeptAdmin(record.id)" v-if="record.ifDepartPrincipal == 0"
            >设置为负责人</a
          >

          <!-- <a-divider type="vertical" />
          <a-dropdown>
            <a class="ant-dropdown-link">更多 <a-icon type="down" /></a>
            <a-menu slot="overlay">
              <a-menu-item>
                <a @click="handleDetail(record)">详情</a>
              </a-menu-item>
              <a-menu-item>
                <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.id)">
                  <a>删除</a>
                </a-popconfirm>
              </a-menu-item>
            </a-menu>
          </a-dropdown> -->
        </span>
      </a-table>
    </div>

    <system-user-modal ref="modalForm" @ok="modalFormOk" :departId="departId"></system-user-modal>
    <a-modal title="设置团队" :visible="visible" @cancel="handleCancel" @ok="handleOk">
          <j-dict-select-tag
            type="list"
            v-model="deptId"
            dictCode="sys_depart,depart_name,id"
            placeholder="请选择招生团队"
            style="width:300px"
          />
    </a-modal>
  </a-card>
</template>

<script>
import '@/assets/less/TableExpand.less'
import { mixinDevice } from '@/utils/mixin'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import SystemUserModal from './modules/SystemUserModal'
import { filterMultiDictText } from '@/components/dict/JDictSelectUtil'
import { axios } from '@/utils/request'
import { getAction } from '@/api/manage'

export default {
  name: 'SystemUserList',
  mixins: [JeecgListMixin, mixinDevice],
  components: {
    SystemUserModal,
  },
  data() {
    return {
      description: 'sys_user管理页面',
      // 表头
      columns: [
        {
          title: '序号',
          dataIndex: '',
          key: 'rowIndex',
          width: 60,
          align: 'center',
          customRender: function (t, r, index) {
            return parseInt(index) + 1
          },
        },
        {
          title: '姓名',
          align: 'center',
          dataIndex: 'realname',
        },
        {
          title: '性别',
          align: 'center',
          dataIndex: 'sex_dictText',
        },
        {
          title: '手机号',
          align: 'center',
          dataIndex: 'phone',
        },
        // {
        //   title: '招生团队',
        //   align: 'center',
        //   dataIndex: 'orgCode_dictText',
        // },
        {
          title: '是否团队负责人',
          align: 'center',
          dataIndex: 'ifDepartPrincipal',
           customRender: function (t, r, index) {
             if(t==0){
               return '否'
             }else{
               return '是'
             }
          },
        },
        // {
        //   title: '是否接待人员',
        //   align: 'center',
        //   dataIndex: 'ifReceptionist',
        // },
        {
          title: '创建时间',
          align: 'center',
          dataIndex: 'createTime',
        },
        {
          title: '操作',
          dataIndex: 'action',
          align: 'center',
          fixed: 'right',
          width: 147,
          scopedSlots: { customRender: 'action' },
        },
      ],
      url: {
        list: '/system/systemUser/list?departId='+localStorage.getItem('departId'),
        delete: '/system/systemUser/delete',
        deleteBatch: '/system/systemUser/deleteBatch',
        exportXlsUrl: '/system/systemUser/exportXls',
        importExcelUrl: 'system/systemUser/importExcel',
      },
      dictOptions: {},
      superFieldList: [],
      visible: false,
      deptId: '',
      taskVisible: false,
      departId:''
    }
  },
  created() {
    this.getSuperFieldList()
    // console.log(this.$route.query.id)
    this.departId = this.$route.query.id
    console.log(this.departId)
  },
  computed: {
    importExcelUrl: function () {
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`
    },
  },
  methods: {
    handleOk(e) {
      this.visible  = false
      //console.log(this.deptId,'*********')
      this.setDept()
    },
    showModal() {
      console.log(this.selectedRowKeys)
      this.visible = true
    },
    handleCancel(e) {
      this.visible = false
    },
    initDictConfig() {},
    getSuperFieldList() {
      let fieldList = []
      fieldList.push({ type: 'string', value: 'realname', text: '姓名', dictCode: '' })
      fieldList.push({ type: 'int', value: 'sex', text: '性别', dictCode: 'sex' })
      fieldList.push({ type: 'string', value: 'phone', text: '手机号', dictCode: '' })
      fieldList.push({
        type: 'string',
        value: 'orgCode',
        text: '招生团队',
        dictCode: 'sys_depart,depart_name,org_code',
      })
      fieldList.push({ type: 'int', value: 'ifDepartPrincipal', text: '是否团队负责人', dictCode: 'yn' })
      fieldList.push({ type: 'int', value: 'ifReceptionist', text: '是否接待人员', dictCode: 'yn' })
      this.superFieldList = fieldList
    },
    setDeptAdmin(userId) {
      axios
        .put('system/systemUser/setDeptAdminByUserId/' + userId)
        .then((res) => {
          //console.log(res)
          if (res.success) {
            this.$message.success('设置成功')
            this.loadData(1)
          }
        })
        .catch((err) => {
          console.log(err)
        })
        .finally(() => {})
    },
    setReceptionist() {
      console.log(this.selectedRowKeys)
      axios
        .put('system/systemUser/setReceptionistList', {
          userIdList: this.selectedRowKeys,
        })
        .then((res) => {
          console.log(res)
          if (res.success) {
            this.$message.success('设置成功')
            this.loadData(1)
          }
        })
        .catch((err) => {
          console.log(err)
        })
        .finally(() => {})
    },
    setDept() {
      axios
        .put('system/systemUser/setDeptByUserIdList', {
          deptId:this.deptId,
          userIdList: this.selectedRowKeys,
        })
        .then((res) => {
          console.log(res)
          if (res.success) {
            this.$message.success('设置成功')
            this.loadData(1)
          }
        })
        .catch((err) => {
          console.log(err)
        })
        .finally(() => {
          this.loadData(1)
        })
    },
    // loadData(arg) {
    //   console.log(this.$route.query.id)
    //   this.url.list = '/system/systemUser/list?departId='+this.$route.query.id
    //   if(!this.url.list){
    //     this.$message.error("请设置url.list属性!")
    //     return
    //   }
    //   //加载数据 若传入参数1则加载第一页的内容
    //   if (arg === 1) {
    //     this.ipagination.current = 1;
    //   }
    //   var params = this.getQueryParams();//查询条件
    //   this.loading = true;
    //   getAction(this.url.list, params).then((res) => {
    //     if (res.success) {
    //       //update-begin---author:zhangyafei    Date:20201118  for：适配不分页的数据列表------------
    //       this.dataSource = res.result.records||res.result;
    //       if(res.result.total)
    //       {
    //         this.ipagination.total = res.result.total;
    //       }else{
    //         this.ipagination.total = 0;
    //       }
    //       //update-end---author:zhangyafei    Date:20201118  for：适配不分页的数据列表------------
    //     }
    //     if(res.code===510){
    //       this.$message.warning(res.message)
    //     }
    //     this.loading = false;
    //   })
    // },
  },
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>