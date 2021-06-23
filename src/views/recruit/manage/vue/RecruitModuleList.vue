<!--模块管理-->
<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">

          <a-col :xl="6" :lg="7" :md="8" :sm="24">
            <a-form-item label="状态">
              <a-select placeholder="请选择状态" v-model="queryParam.fmStatus">
                <a-select-option value="Y">
                  启用
                </a-select-option>
                <a-select-option value="N">
                  禁用
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
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
      <a-button @click="handleAdd" type="primary" icon="plus">添加模块</a-button>
      <!-- <a-button type="primary" icon="download" @click="handleExportXls('模块表')">导出</a-button>
      <a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">
        <a-button type="primary" icon="import">导入</a-button>
      </a-upload> -->
      <!-- 高级查询区域 -->
      <!-- <j-super-query :fieldList="superFieldList" ref="superQueryModal" @handleSuperQuery="handleSuperQuery"></j-super-query>
      <a-dropdown v-if="selectedRowKeys.length > 0">
        <a-menu slot="overlay">
          <a-menu-item key="1" @click="batchDel"><a-icon type="delete"/>删除</a-menu-item>
        </a-menu>
        <a-button style="margin-left: 8px"> 批量操作 <a-icon type="down" /></a-button>
      </a-dropdown> -->
    </div>

    <!-- table区域-begin -->
    <div>
      <!-- <div class="ant-alert ant-alert-info" style="margin-bottom: 16px;">
        <i class="anticon anticon-info-circle ant-alert-icon"></i> 已选择 <a style="font-weight: 600">{{ selectedRowKeys.length }}</a>项
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
        :loading="loading"
        class="j-table-force-nowrap"
        @change="handleTableChange"
        :pagination="ipagination"
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

        <span slot="action" slot-scope="text, record, index">
          <a-popconfirm title="确定删除吗?" @confirm="() => handleDelete(record.id)">
            <a v-if="record.moduleType == 2">删除</a>
          </a-popconfirm>
          <a @click="handleEdit(record)" v-if="record.moduleType == 1">编辑</a>
          <a-divider type="vertical" />
          <a @click="handleEdit(record)" v-if="record.moduleType == 2">设置内容</a>
          <a @click="toModulePage(record.sysPerId,record.id)" v-if="record.moduleType == 1">设置内容</a>
          <a-divider type="vertical" v-if="record.fmStatus == 'N'" />
          <a @click="handleDetail(record)" v-if="record.fmStatus == 'N'">详情</a>
          <a-divider type="vertical" />
          <a @click="sortOrder(record.id, 'up')" :disabled="index == 0">上移</a>
          <a-divider type="vertical" />
          <a @click="sortOrder(record.id, 'down')" :disabled="index + 1 == dataSource.length">下移</a>
          <a-divider type="vertical" />
          <a @click="updateStatus(record.id,'Y')" v-if="record.fmStatus == 'N'">启用</a>
          <a @click="updateStatus(record.id,'N')" v-if="record.fmStatus == 'Y'">禁用</a>
        </span>
      </a-table>
    </div>

    <recruit-module-modal ref="modalForm" @ok="modalFormOk"></recruit-module-modal>
  </a-card>
</template>

<script>
import '@/assets/less/TableExpand.less'
import { mixinDevice } from '@/utils/mixin'
import { JeecgListMixin } from '@/mixins/JeecgListMixin'
import RecruitModuleModal from './modules/RecruitModuleModal'
import { filterMultiDictText } from '@/components/dict/JDictSelectUtil'
import { axios } from '@/utils/request'

export default {
  name: 'RecruitModuleList',
  mixins: [JeecgListMixin, mixinDevice],
  components: {
    RecruitModuleModal,
  },
  data() {
    return {
      description: '模块表管理页面',
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
          title: '图标',
          align: 'center',
          dataIndex: 'moduleIcon',
          scopedSlots: { customRender: 'imgSlot' },
        },
        {
          title: '模块类型',
          align: 'center',
          dataIndex: 'moduleType_dictText',
        },
        {
          title: '模块名称',
          align: 'center',
          dataIndex: 'moduleName',
        },
        {
          title: '操作',
          dataIndex: 'action',
          align: 'center',
          fixed: 'right',
          width: 400,
          scopedSlots: { customRender: 'action' },
        },
      ],
      url: {
        list: '/manage/recruitModule/list',
        delete: '/manage/recruitModule/delete',
        deleteBatch: '/manage/recruitModule/deleteBatch',
        exportXlsUrl: '/manage/recruitModule/exportXls',
        importExcelUrl: 'manage/recruitModule/importExcel',
      },
      dictOptions: {},
      superFieldList: [],
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
    initDictConfig() {},
    getSuperFieldList() {
      let fieldList = []
      fieldList.push({ type: 'int', value: 'moduleType', text: '模块类型', dictCode: 'mf_type' })
      fieldList.push({ type: 'string', value: 'moduleIcon', text: '图标', dictCode: '' })
      fieldList.push({ type: 'string', value: 'moduleName', text: '模块名称', dictCode: '' })
      fieldList.push({ type: 'string', value: 'title', text: '标题', dictCode: '' })
      fieldList.push({ type: 'Text', value: 'cmContent', text: '模块内容', dictCode: '' })
      fieldList.push({ type: 'Text', value: 'cmFile', text: '附件', dictCode: '' })
      this.superFieldList = fieldList
    },
    toModulePage(sysPerId,moduleId) {
      console.log(sysPerId)
      console.log(moduleId)
      switch (sysPerId) {
        case '1':
          // this.$router.push({ name: 'recruit-manage-vue-RecruitSchoolInfo',params: { moduleId }})
          this.$router.push({path: '/recruit/manage/vue/RecruitSchoolInfo', query: {moduleId}})
          break
        case '2':
          this.$router.push({ name: 'manage-recruitCollegeInfo' })
          break
        case '3':
          this.$router.push({ name: 'manage-recruitMajorInfo' })
          break
        case '4':
          this.$router.push({ name: 'manage-recruitTeacherInfo' })
          break
        case '5':
          this.$router.push({ name: 'recruit-manage-vue-RecruitPic' })
          break
        case '6':
          this.$router.push({ name: 'manage-recruitVideoAbout' })
          break
        case '7':
          this.$router.push({ name: 'manage-recruitAdmissionScore' })
          break
        case '8':
          this.$router.push({ name: 'manage-recruitAdmissionStudent' })
          break
        default:
          break
      }
    },
    sortOrder(id, direction) {
      axios
        .put('manage/recruitModule/sortRecruitModule', {
          id: id,
          direction: direction,
        })
        .then((res) => {
          //console.log(res)
          if (res.success) {
            this.loadData(1)
          }
        })
        .catch((err) => {
          console.log(err)
        })
        .finally(() => {})
    },
    updateStatus(id, status) {
      axios
        .put('manage/recruitModule/updateRecruitModuleStatus', {
          id: id,
          status: status,
        })
        .then((res) => {
          //console.log(res)
          if (res.success) {
            this.loadData(1)
          }else{
            this.$message.warning(res.message)
          }
        })
        .catch((err) => {
          console.log(err)
        })
        .finally(() => {})
    },
  },
}
</script>
<style scoped>
@import '~@assets/less/common.less';
/deep/.ant-table-body tr{
  height: 50px !important;
}
</style>