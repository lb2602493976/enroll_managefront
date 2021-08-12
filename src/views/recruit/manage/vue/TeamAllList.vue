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
      <!-- <a-button @click="handleAdd" type="primary" icon="plus">新增</a-button> -->
      <!-- <a-button type="primary" icon="download" @click="handleExportXls('招生咨询')">导出</a-button>
      <a-upload name="file" :showUploadList="false" :multiple="false" :headers="tokenHeader" :action="importExcelUrl" @change="handleImportExcel">
        <a-button type="primary" icon="import">导入</a-button>
      </a-upload> -->
      <!-- 高级查询区域 -->
      <!-- <j-super-query :fieldList="superFieldList" ref="superQueryModal" @handleSuperQuery="handleSuperQuery"></j-super-query> -->
      <!-- <a-dropdown v-if="selectedRowKeys.length > 0">
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
        :rowSelection="{selectedRowKeys: selectedRowKeys, onChange: onSelectChange}"
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
          <!-- 0：待审核，1：审核通过， 2：审核拒绝 */ -->
          <!-- <a v-if="status" @click="handleEdit(record)">审核</a> -->
          <a-popconfirm title="确定要审核通过吗?" @confirm="() => handleYes(record.id)">
            <a>审核通过</a>
          </a-popconfirm>
          <a-divider type="vertical" />
          <a-popconfirm title="确定要审核拒绝吗?" @confirm="() => handleNo(record.id)">
            <a>审核拒绝</a>
          </a-popconfirm>
          <!-- <a-divider type="vertical" />
          <a @click="handleDetail(record)">图片详情</a> -->
           <!-- <a-divider type="vertical" /> -->
          <!-- <a @click="handleEdit(record)">审核拒绝</a> -->

         
          <!-- <a-dropdown>
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

    <admission-counseling-modal ref="modalForm" @ok="modalFormOk"></admission-counseling-modal>
  </a-card>
</template>

<script>

  import '@/assets/less/TableExpand.less'
  import { mixinDevice } from '@/utils/mixin'
  import { JeecgListMixin } from '@/mixins/JeecgListMixinTeamAllList'
  // import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import AdmissionCounselingModal from './modules/TeamToAuditListModal'

  export default {
    name: 'AdmissionCounselingList',
    mixins:[JeecgListMixin, mixinDevice],
    components: {
      AdmissionCounselingModal
    },
    data () {
      return {
        description: '新增用户数页面',
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
          // {
          //   title:'租户id',
          //   align:"center",
          //   dataIndex: 'tenantId'
          // },
          {
            title:'注册时间',
            align:"center",
            dataIndex: 'time'
          },
          {
            title:'姓名',
            align:"center",
            dataIndex: 'name'
            // dataIndex: 'userName'
          },
          {
            title:'电话',
            align:"center",
            dataIndex: 'phone'
          },
          // {
          //   title:'性别',
          //   align:"center",
          //   dataIndex: 'gender'
          // },
          {
            title:'微信二维码',
            align:"center",
            dataIndex: 'wechatUrl',
            scopedSlots: { customRender: 'imgSlot' },
          },
          {
            title:'照片',
            align:"center",
            dataIndex: 'photoUrl',
            scopedSlots: { customRender: 'imgSlot' },
          },
          {
            title:'负责区域',
            align:"center",
            dataIndex: 'area'
          },
          // {
          //   title:'团队名称',
          //   align:"center",
          //   dataIndex: 'teamName'
          // },
          // {
          //   title:'openid',
          //   align:'center',
          //   dataIndex:'openId'
          // },
          
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
          list: "/manage/teamPersonnel/getCheckAdminList",
          delete: "manage/teamPersonnel/edit",
          // yesOrNo:"manage/teamPersonnel/edit",
          deleteBatch: "/manage/admissionCounseling/deleteBatch",
          exportXlsUrl: "/manage/admissionCounseling/exportXls",
          importExcelUrl: "manage/admissionCounseling/importExcel",
          
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
        // fieldList.push({type:'string',value:'tenantId',text:'租户id',dictCode:''})
        fieldList.push({type:'string',value:'wechatUrl',text:'微信二维码',dictCode:''})
        fieldList.push({type:'string',value:'photoUrl',text:'照片',dictCode:''})
        // fieldList.push({type:'string',value:'schoolWebsite',text:'学校网址',dictCode:''})
        // fieldList.push({type:'string',value:'admissionsWebsite',text:'招生网址',dictCode:''})
        // fieldList.push({type:'string',value:'admissionsTel',text:'招生办电话',dictCode:''})
        this.superFieldList = fieldList
      }
    }
  }
</script>
<style scoped>
  @import '~@assets/less/common.less';
</style>