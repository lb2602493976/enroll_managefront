<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24"> </a-row>
      </a-form>
    </div>
    <!-- 查询区域-END -->

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <!-- <a-button @click="handleAdd" type="primary" icon="plus">创建团队</a-button> -->
      <!-- <a-button type="primary" @click="taskShowModal()">设置招生任务</a-button> -->
      <!-- <a-button type="primary" icon="download" @click="handleExportXls('sys_depart')">导出</a-button>
      <a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">
        <a-button type="primary" icon="import">导入</a-button>
      </a-upload> -->
      <!-- 高级查询区域 -->
      <!-- <j-super-query :fieldList="superFieldList" ref="superQueryModal" @handleSuperQuery="handleSuperQuery"></j-super-query> -->
      <a-dropdown v-if="selectedRowKeys.length > 0">
        <a-menu slot="overlay">
          <a-menu-item key="1" @click="batchDel"><a-icon type="delete" />删除</a-menu-item>
        </a-menu>
        <a-button style="margin-left: 8px"> 批量操作 <a-icon type="down" /></a-button>
      </a-dropdown>
    </div>

    <!-- table区域-begin -->
    <div>
      <div class="ant-alert ant-alert-info" style="margin-bottom: 16px">
        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择
        <a style="font-weight: 600">{{ selectedRowKeys.length }}</a
        >项
        <a style="margin-left: 24px" @click="onClearSelected">清空</a>
      </div>

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
        :rowSelection="{ selectedRowKeys: selectedRowKeys, onChange: onSelectChange }"
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
          <a @click="handleEdit(record)">编辑</a>

          <a-divider type="vertical" />
          <a @click="toPeopleDetail(record.id)">查看人员</a>
          <!-- <a-dropdown>
            <a class="ant-dropdown-link">更多 <a-icon type="down" /></a>
            <a-menu slot="overlay">
              <a-menu-item>
                
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

    <system-depart-modal ref="modalForm" @ok="modalFormOk"></system-depart-modal>
    <!-- <a-modal title="团队详情" :visible="visible"   @cancel="handleCancel" :footer="null">
      <a-table
        ref="table"
        size="middle"
        :scroll="{ x: true }"
        bordered
        rowKey="id"
        :columns="modalColumns"
        :dataSource="modalDataSource"
        :loading="loading"
        class="j-table-force-nowrap"
        @change="handleTableChange"
      >
      </a-table>
    </a-modal> -->

    <a-modal title="设置招生任务" :visible="taskVisible"   @cancel="taskHandleCancel" @ok="taskHandleOk">
      <a-table
        ref="table"
        size="middle"
        :scroll="{ x: true }"
        bordered
        rowKey="id"
        :columns="taskColumns"
        :dataSource="dataSource"
        :loading="loading"
        class="j-table-force-nowrap"
        @change="handleTableChange"
      >
      </a-table>
    </a-modal>
  </a-card>
</template>

<script>
import '@/assets/less/TableExpand.less'
import { mixinDevice } from '@/utils/mixin'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import SystemDepartModal from './modules/SystemDepartModal'
import { axios } from '@/utils/request'

export default {
  name: 'SystemDepartList',
  mixins: [JeecgListMixin, mixinDevice],
  components: {
    SystemDepartModal,
  },
  data() {
    return {
      description: 'sys_depart管理页面',
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
          title: '团队名称',
          align: 'center',
          dataIndex: 'departName',
        },
        {
          title: '团队负责人',
          align: 'center',
          dataIndex: 'departNameEn',
        },
        {
          title: '团队人数',
          align: 'center',
          dataIndex: 'departOrder',
        },
        {
          title: '招生任务数',
          align: 'center',
          dataIndex: 'departTaskNum',
        },
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
        list: '/system/systemDepart/list?orgCategory=2',
        delete: '/system/systemDepart/delete',
        deleteBatch: '/system/systemDepart/deleteBatch',
        exportXlsUrl: '/system/systemDepart/exportXls',
        importExcelUrl: 'system/systemDepart/importExcel',
      },
      modalColumns: [
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
          title: '职位',
          align: 'center',
          dataIndex: 'post',
        },
        {
          title: '电话',
          align: 'center',
          dataIndex: 'phone',
        },
      ],
      url: {
        list: '/system/systemDepart/list',
        delete: '/system/systemDepart/delete',
        deleteBatch: '/system/systemDepart/deleteBatch',
        exportXlsUrl: '/system/systemDepart/exportXls',
        importExcelUrl: 'system/systemDepart/importExcel',
      },
      dictOptions: {},
      superFieldList: [],
      visible: false,
      modalDataSource:[],
      deptId:'',
      taskVisible:false,
      taskColumns: [
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
          title: '团队名称',
          align: 'center',
          dataIndex: 'departName',
        },
        {
          title: '团队负责人',
          align: 'center',
          dataIndex: 'departNameEn',
        },
        {
          title: '招生任务数',
          align: 'center',
          dataIndex: 'departTaskNum',
        },
      ],
    }
  },
  created() {
    this.getSuperFieldList()
  },
  computed: {
    importExcelUrl: function () {
      return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`
    },
  },
  methods: {
    // showModal(deptId) {
    //   this.deptId = deptId
    //   this.getUserByDept();
    //   this.visible = true
    // },
    handleCancel(e) {
      this.visible = false
    },
    taskShowModal() {
      this.taskVisible = true
    },
    taskHandleCancel(e) {
      this.taskVisible = false
    },
    taskHandleOk(){
      this.taskVisible = false
    },
    initDictConfig() {},
    getSuperFieldList() {
      let fieldList = []
      fieldList.push({ type: 'string', value: 'parentId', text: '父机构ID', dictCode: '' })
      fieldList.push({ type: 'string', value: 'departName', text: '机构/部门名称', dictCode: '' })
      fieldList.push({ type: 'string', value: 'departNameEn', text: '英文名', dictCode: '' })
      fieldList.push({ type: 'string', value: 'departNameAbbr', text: '缩写', dictCode: '' })
      fieldList.push({ type: 'int', value: 'departOrder', text: '排序', dictCode: '' })
      fieldList.push({ type: 'string', value: 'description', text: '描述', dictCode: '' })
      fieldList.push({ type: 'string', value: 'orgCategory', text: '机构类别 1公司，2组织机构，2岗位', dictCode: '' })
      fieldList.push({ type: 'string', value: 'orgType', text: '机构类型 1一级部门 2子部门', dictCode: '' })
      fieldList.push({ type: 'string', value: 'orgCode', text: '机构编码', dictCode: '' })
      fieldList.push({ type: 'string', value: 'mobile', text: '手机号', dictCode: '' })
      fieldList.push({ type: 'string', value: 'fax', text: '传真', dictCode: '' })
      fieldList.push({ type: 'string', value: 'address', text: '地址', dictCode: '' })
      fieldList.push({ type: 'string', value: 'memo', text: '备注', dictCode: '' })
      fieldList.push({ type: 'string', value: 'status', text: '状态（1启用，0不启用）', dictCode: '' })
      fieldList.push({ type: 'string', value: 'delFlag', text: '删除状态（0，正常，1已删除）', dictCode: '' })
      fieldList.push({ type: 'string', value: 'tenantId', text: '租户id', dictCode: '' })
      fieldList.push({ type: 'int', value: 'departTaskNum', text: '团队任务数', dictCode: '' })
      this.superFieldList = fieldList
    },
    getUserByDept(){
      axios.get('system/systemDepart/getUserByDept/'+this.deptId).then((res)=>{
        console.log(res)
        this.modalDataSource = res.result
      }).catch((err)=>{

      }).finally(()=>{

      })
    },
    toPeopleDetail(id){
      localStorage.setItem('departId',id)
      this.$router.push({path:'/system/systemUser'})
    },
  },
}
</script>
<style scoped>
@import '~@assets/less/common.less';
</style>