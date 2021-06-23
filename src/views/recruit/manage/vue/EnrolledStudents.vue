<template>
  <a-row :gutter="10">
    <a-card :bordered="false">
      <!-- 查询区域 -->
      <div class="table-page-search-wrapper">
        <!-- 搜索区域 -->
        <a-form layout="inline" @keyup.enter.native="searchQuery">
          <a-row :gutter="24">
            <a-col :md="12" :sm="8">
              <a-form-item label="时间" :labelCol="{span: 5}" :wrapperCol="{span: 18, offset: 1}">
<!--                <a-input placeholder="" v-model="queryParam.time"></a-input>-->
                <a-date-picker placeholder="请选择时间" v-model="queryParam.time" @change="getTime" :format="dateFormat" style="width: 100%" />
              </a-form-item>
            </a-col>
            <span style="" class="table-page-search-submitButtons">
              <a-col :md="2" :sm="24">
                 <a-button type="primary" @click="searchQuery" icon="search" >查询</a-button>
                <a-button type="primary" @click="searchReset" icon="reload" style="margin-left: 8px">重置</a-button>
              </a-col>
          </span>
          </a-row>
        </a-form>
      </div>
      <!-- 操作按钮区域 -->
      <div class="table-operator" style="margin: 5px 0 10px 2px">
        <a-button type="primary" icon="download" @click="handleExportXls('报名学生')">导出</a-button>
      </div>

      <div style="margin-top: 15px">
        <a-table
          ref="table"
          bordered
          size="middle"
          rowKey="id"
          :columns="columns"
          :dataSource="dataSource"
          :pagination="ipagination"
          :loading="loading"
          @change="handleTableChange"
        >
        </a-table>
      </div>
    </a-card>
  </a-row>
</template>
<script>
  import { JeecgListMixin } from '@/mixins/JeecgListMixin'
  import { deleteAction, postAction, getAction } from '@/api/manage'
  import { filterObj } from '@/utils/util'
  import moment from 'moment'

  export default {
    name: 'EnrolledStudents',
    mixins: [JeecgListMixin],
    data() {
      return {
        columns:
          [
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
              title: '创建日期',
              dataIndex: 'create_time',
              align:"center",
            },
            {
              title: '手机号',
              align: 'center',
              dataIndex: 'phone'
            },
            {
              title: '学生姓名',
              align: 'center',
              dataIndex: 'stu_name'
            },
            {
              title: '备注',
              align: 'center',
              dataIndex: 'remarks'
            }
          ],
        url: {
          list: '/manage/recruitStudent/StuList',
          exportXlsUrl: 'manage/recruitStudent/exportXls',
        },
        pagination: {
          current: 1,
          pageSize: 10,
          pageSizeOptions: ['10', '20', '30', '100', '200'],
          total: 1000,
        },
        dateFormat: 'YYYY-MM-DD',
      }
    },
    computed: {
    },
    methods: {
      moment,
      handleTablePageChange(event) {
        // 重新赋值
        this.pagination.current = event.current
        this.pagination.pageSize = event.pageSize
        // 查询数据
        this.loadData()
        // 判断树展开的key
        if (event.current <= 10) {
          this.treeExpandedKeys = ['1-10']
        } else {
          this.treeExpandedKeys = ['11-20']
        }
      },
      getTime(date, dateString){
        this.queryParam.time =dateString
      }
    }
  }
</script>
<style scoped>
  /** Button按钮间距 */
  .ant-btn {
    margin-left: 8px
  }
</style>