<template>
  <a-card :bordered="false">
    <!-- 查询区域 -->
    <div class="table-page-search-wrapper">
      <a-form layout="inline" @keyup.enter.native="searchQuery">
        <a-row :gutter="24">
        </a-row>
      </a-form>
    </div>
    <!-- 查询区域-END -->

    <!-- 操作按钮区域 -->
    <div class="table-operator">
      <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button>
      <a-button type="primary" icon="download" @click="handleExportXls('录取学生表')">导出</a-button>
      <a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">
        <a-button type="primary" icon="import">导入</a-button>
      </a-upload>
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
        :scroll="{x:true}"
        bordered
        rowKey="id"
        :columns="columns"
        :dataSource="dataSource"
        :pagination="ipagination"
        :loading="loading"
        class="j-table-force-nowrap"
        @change="handleTableChange">

        <template slot="htmlSlot" slot-scope="text">
          <div v-html="text"></div>
        </template>
        <template slot="imgSlot" slot-scope="text">
          <span v-if="!text" style="font-size: 12px;font-style: italic;">无图片</span>
          <img v-else :src="getImgView(text)" height="25px" alt="" style="max-width:80px;font-size: 12px;font-style: italic;"/>
        </template>
        <template slot="fileSlot" slot-scope="text">
          <span v-if="!text" style="font-size: 12px;font-style: italic;">无文件</span>
          <a-button
            v-else
            :ghost="true"
            type="primary"
            icon="download"
            size="small"
            @click="downloadFile(text)">
            下载
          </a-button>
        </template>

        <span slot="action" slot-scope="text, record">
          <a @click="handleEdit(record)">编辑</a>

          <a-divider type="vertical" />
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
          </a-dropdown>
        </span>

      </a-table>
    </div>

    <recruit-admission-student-modal ref="modalForm" @ok="modalFormOk"></recruit-admission-student-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import RecruitAdmissionStudentModal from './modules/RecruitAdmissionStudentModal'

  export default {
    name: 'RecruitAdmissionStudentList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      RecruitAdmissionStudentModal
    },
    data () {
      return {
        description: '录取学生表管理页面',
        // 表头
        columns: [
          {
            title: '序号',
            dataIndex: '',
            key:'rowIndex',
            width:60,
            align:"center",
            customRender:function (t,r,index) {
              return parseInt(index)+1;
            }
          },
          {
            title:'学生姓名',
            align:"center",
            dataIndex: 'stuName'
          },
          {
            title:'性别',
            align:"center",
            dataIndex: 'gender'
          },
          {
            title:'民族',
            align:"center",
            dataIndex: 'nation'
          },
          {
            title:'头像',
            align:"center",
            dataIndex: 'headPortrait'
          },
          {
            title:'政治面貌',
            align:"center",
            dataIndex: 'politicalStatus'
          },
          {
            title:'身份证号',
            align:"center",
            dataIndex: 'idCard'
          },
          {
            title:'手机号码',
            align:"center",
            dataIndex: 'phone'
          },
          {
            title:'所在地区',
            align:"center",
            dataIndex: 'region'
          },
          {
            title:'地区编码',
            align:"center",
            dataIndex: 'regionCode'
          },
          {
            title:'家庭住址',
            align:"center",
            dataIndex: 'address'
          },
          {
            title:'毕业学校',
            align:"center",
            dataIndex: 'graduatedSchool'
          },
          {
            title:'准考证号',
            align:"center",
            dataIndex: 'examinationNumber'
          },
          {
            title:'考生号',
            align:"center",
            dataIndex: 'examNumber'
          },
          {
            title:'是否跟读',
            align:"center",
            dataIndex: 'ifFollow'
          },
          {
            title:'计划性质',
            align:"center",
            dataIndex: 'planType'
          },
          {
            title:'学籍年',
            align:"center",
            dataIndex: 'schoolYear'
          },
          {
            title:'院系',
            align:"center",
            dataIndex: 'deptName'
          },
          {
            title:'录取专业',
            align:"center",
            dataIndex: 'majorName'
          },
          {
            title:'总成绩',
            align:"center",
            dataIndex: 'enterScore'
          },
          {
            title:'考生类型',
            align:"center",
            dataIndex: 'examineeType'
          },
          {
            title:'考生类别',
            align:"center",
            dataIndex: 'examineeCategory'
          },
          {
            title: '操作',
            dataIndex: 'action',
            align:"center",
            fixed:"right",
            width:147,
            scopedSlots: { customRender: 'action' }
          }
        ],
        url: {
          list: "/manage/recruitAdmissionStudent/list",
          delete: "/manage/recruitAdmissionStudent/delete",
          deleteBatch: "/manage/recruitAdmissionStudent/deleteBatch",
          exportXlsUrl: "/manage/recruitAdmissionStudent/exportXls",
          importExcelUrl: "manage/recruitAdmissionStudent/importExcel",
          
        },
        dictOptions:{},
        superFieldList:[],
      }
    },
    created() {
    this.getSuperFieldList();
    },
    computed: {
      importExcelUrl: function(){
        return `${window._CONFIG['domianURL']}/${this.url.importExcelUrl}`;
      },
    },
    methods: {
      initDictConfig(){
      },
      getSuperFieldList(){
        let fieldList=[];
        fieldList.push({type:'int',value:'tenantId',text:'租户id',dictCode:''})
        fieldList.push({type:'string',value:'stuName',text:'学生姓名',dictCode:''})
        fieldList.push({type:'int',value:'gender',text:'性别',dictCode:''})
        fieldList.push({type:'string',value:'nation',text:'民族',dictCode:''})
        fieldList.push({type:'string',value:'headPortrait',text:'头像',dictCode:''})
        fieldList.push({type:'int',value:'politicalStatus',text:'政治面貌',dictCode:''})
        fieldList.push({type:'string',value:'idCard',text:'身份证号',dictCode:''})
        fieldList.push({type:'string',value:'phone',text:'手机号码',dictCode:''})
        fieldList.push({type:'string',value:'region',text:'所在地区',dictCode:''})
        fieldList.push({type:'string',value:'regionCode',text:'地区编码',dictCode:''})
        fieldList.push({type:'string',value:'address',text:'家庭住址',dictCode:''})
        fieldList.push({type:'string',value:'graduatedSchool',text:'毕业学校',dictCode:''})
        fieldList.push({type:'string',value:'examinationNumber',text:'准考证号',dictCode:''})
        fieldList.push({type:'string',value:'examNumber',text:'考生号',dictCode:''})
        fieldList.push({type:'int',value:'ifFollow',text:'是否跟读',dictCode:''})
        fieldList.push({type:'int',value:'planType',text:'计划性质',dictCode:''})
        fieldList.push({type:'int',value:'schoolYear',text:'学籍年',dictCode:''})
        fieldList.push({type:'string',value:'deptName',text:'院系',dictCode:''})
        fieldList.push({type:'string',value:'majorName',text:'录取专业',dictCode:''})
        fieldList.push({type:'string',value:'enterScore',text:'总成绩',dictCode:''})
        fieldList.push({type:'int',value:'examineeType',text:'考生类型',dictCode:''})
        fieldList.push({type:'int',value:'examineeCategory',text:'考生类别',dictCode:''})
        this.superFieldList = fieldList
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>