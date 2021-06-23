<!--宣传图片-->
<template>
  <div>
    <!--    学校端-->
    <a-card :bordered="false">
      <div style="marginbottom: '16px'; display: flex; justify-content: flex-end">
        <a-button v-if="type" type="primary" @click="addImgs"> 添加皮肤 </a-button>
      </div>
      <div style="margin-top: 2%; display: flex; flex-wrap: wrap">
        <template v-for="(item, index) in skinList">
          <a-card hoverable style="width: 19%; margin: 5px">
            <div style="width: 100%; height: 150px">
              <img width="100%" :src="item.skin_pic" slot="cover" alt="" @click="handlePreview(item)" />
            </div>

            <template slot="actions" class="ant-card-actions">
              <!--              <a-icon key="setting" type="setting" />-->
              <!--学校 2 -->
              <template v-if="!type">
                <span @click="detailList(item)">详情</span>
                <a-popconfirm
                  title="确定使用该皮肤"
                  ok-text="是"
                  cancel-text="否"
                  @confirm="confirm(2, item)"
                  @cancel="cancel(2, item)"
                  v-if="item.as_use === '0'"
                >
                  <span>使用</span>
                </a-popconfirm>
                <span v-if="item.as_use === '1'">使用中</span>
                <span v-if="item.as_use === '2'"
                  >购买 <span style="color: red">￥{{ item.price }}</span></span
                >
              </template>
              <!--平台 1 -->
              <template v-if="type">
                <span @click="detailList(item)">编辑</span>
                <span>使用数{{ item.num }}</span>
                <!--                <a-popconfirm-->
                <!--                  :title="`确定${item.or_enable === '1' ? '下架' : '上架'}该皮肤`"-->
                <!--                  ok-text="是"-->
                <!--                  cancel-text="否"-->
                <!--                  @confirm="confirm(1,item)"-->
                <!--                  @cancel="cancel(1,item)"-->
                <!--                >-->
                <!--                  <span>{{item.or_enable === '1' ? '下架' : '上架' }}</span>-->
                <!--                </a-popconfirm>-->
              </template>
            </template>
            <a-card-meta>
              <!--            <a-card-meta :title="item.skin_name" :description="item.skin_introduce && item.skin_introduce.substring(0,10)">-->
              <template slot="description">
                <a-popover trigger="hover">
                  <template slot="content">
                    {{ item.skin_introduce }}
                  </template>
                  {{ item.skin_introduce ? item.skin_introduce.substring(0, 10) + '...' : '暂无描述' }}
                </a-popover>
                <!--                {{item.skin_introduce ? item.skin_introduce.substring(0,10)+"..." : '暂无描述'}}-->
              </template>
              <template slot="title">
                {{ item.skin_name }}
              </template>
            </a-card-meta>
          </a-card>
        </template>
      </div>
    </a-card>
    <a-modal
      title="详情"
      width="800px"
      :visible="tabVisible"
      :confirm-loading="confirmTabLoading"
      @ok="handleOkTab"
      @cancel="handleCancelTab"
    >
      <div slot="footer" v-if="!type"></div>
      <a-form-model :model="imgDetail" :rules="validatorRules" ref="form1">
        <a-form-model-item
          label="名称"
          prop="skin_name"
          :label-col="formItemLayout.labelCol"
          :wrapper-col="formItemLayout.wrapperCol"
        >
          <a-input
            v-model="imgDetail.skin_name"
            placeholder="请输入名称（不超过10个字）"
            :maxLength="10"
            :disabled="!type"
          ></a-input>
        </a-form-model-item>
        <a-form-model-item
          label="价格"
          prop="price"
          :label-col="formItemLayout.labelCol"
          :wrapper-col="formItemLayout.wrapperCol"
        >
          <a-input v-model="imgDetail.price" placeholder="请输入价格" :maxLength="10" :disabled="!type"></a-input>
        </a-form-model-item>
        <a-form-model-item label="介绍" :label-col="formItemLayout.labelCol" :wrapper-col="formItemLayout.wrapperCol">
          <!--          <a-input v-model="imgDetail.skin_introduce" placeholder="请输入介绍" :maxLength="10" :disabled="!type"></a-input>-->
          <a-textarea
            :disabled="!type"
            :maxLength="200"
            v-model="imgDetail.skin_introduce"
            placeholder="请输入介绍"
            :auto-size="{ minRows: 3, maxRows: 5 }"
          />
        </a-form-model-item>
        <a-form-model-item label="图片" :label-col="formItemLayout.labelCol" :wrapper-col="formItemLayout.wrapperCol">
          <div v-if="type">
            <a-upload
              :action="uploadAction"
              :headers="headers"
              :file-list="imgList"
              list-type="picture"
              class="upload-list-inline"
              @change="handleChangeDetail"
            >
              <a-button> <a-icon type="upload" /> 上传 </a-button>
            </a-upload>
            <span v-if="urlIMG" style="color: red; font-size: 14px">请上传图片!</span>
          </div>

          <img v-else width="100%" :src="urls" :alt="imgDetail.skin_name" />
        </a-form-model-item>
      </a-form-model>
    </a-modal>

    <a-modal
      destroyOnClose
      title="添加皮肤"
      width="800px"
      :visible="imageVisible"
      :confirm-loading="confirmImageLoading"
      @ok="handleOkImage"
      @cancel="handleCancelImage"
    >
      <a-form-model :model="saveParm" :rules="validatorRules" ref="form">
        <a-form-model-item
          prop="skinName"
          label="名称"
          :label-col="formItemLayout.labelCol"
          :wrapper-col="formItemLayout.wrapperCol"
        >
          <a-input v-model="saveParm.skinName" placeholder="请输入名称（不超过10个字）" :maxLength="10"></a-input>
        </a-form-model-item>
        <a-form-model-item
          label="价格"
          prop="price"
          :label-col="formItemLayout.labelCol"
          :wrapper-col="formItemLayout.wrapperCol"
        >
          <a-input v-model="saveParm.price" placeholder="请输入价格"></a-input>
        </a-form-model-item>
        <a-form-model-item label="介绍" :label-col="formItemLayout.labelCol" :wrapper-col="formItemLayout.wrapperCol">
          <a-textarea
            v-model="saveParm.skinIntroduce"
            placeholder="请输入介绍"
            :maxLength="200"
            :auto-size="{ minRows: 3, maxRows: 5 }"
          />
        </a-form-model-item>
        <a-form-model-item label="图片" :label-col="formItemLayout.labelCol" :wrapper-col="formItemLayout.wrapperCol">
          <a-upload
            :action="uploadAction"
            :headers="headers"
            :file-list="imgLists"
            list-type="picture"
            class="upload-list-inline"
            @change="handleChangeAdd"
          >
            <a-button> <a-icon type="upload" /> 上传 </a-button>
          </a-upload>
          <span v-if="urlIMG" style="color: red; font-size: 14px">请上传图片!</span>
        </a-form-model-item>
      </a-form-model>
    </a-modal>

    <a-modal width="1000px" :visible="previewVisible" :footer="null" @cancel="handleCancel">
      <img alt="" style="width: 100%" :src="bigImg" />
    </a-modal>
  </div>
</template>

<script>
import moment from 'moment'
import PageLayout from '@/components/page/PageLayout'
import STable from '@/components/table/'
import DetailList from '@/components/tools/DetailList'
import ABadge from 'ant-design-vue/es/badge/Badge'
const DetailListItem = DetailList.Item
import { axios } from '@/utils/request'
import { ACCESS_TOKEN } from '@/store/mutation-types'
export default {
  components: {
    PageLayout,
    ABadge,
    DetailList,
    DetailListItem,
    STable,
  },
  data() {
    return {
      urls: 'OHR.GlassIgloos_ZH-CN8927574757_UHD_1622446650128.GlassIgloos_ZH-CN8927574757_UHD.jpg',
      uploadAction: window._CONFIG['domianURL'] + '/sys/common/upload',
      preview: window._CONFIG['domianURL'] + '/sys/common/static/',
      headers: {
        'X-Access-Token': this.$ls.get(ACCESS_TOKEN),
      },
      dateFormat: 'YYYY-MM-DD',
      tabVisible: false, // 新增标签模态窗
      imageVisible: false, // 新增图片模态窗
      confirmImageLoading: false, // 新增图片加载动画
      confirmTabLoading: false, // 新增标签加载动画
      previewImage: '',
      formItemLayout: {
        labelCol: { span: 6 },
        wrapperCol: { span: 14 },
      },
      type: true,
      skinList: [],
      imgDetail: {},
      saveParm: {
        skinName: undefined,
        skinIntroduce: undefined,
        skinPic: undefined,
        price: 0,
      },
      urlIMG: false,
      previewVisible: false,
      imgList: [],
      imgLists: [],
      bigImg: '',
      validatorRules: {
        skinName: [{ required: true, message: '请输入名称!' }],
        skin_name: [{ required: true, message: '请输入名称!' }],
        price: [
          { required: true, message: '请输入价格!' },
          { pattern: /^[0-9]+(\.[0-9]{1,2})?$/, message: '请输入正确的价格!' },
        ],
      },
    }
  },
  created() {
    this.getTabsList()
  },
  methods: {
    // 编辑保存
    handleOkTab() {
      const that = this
      // 触发表单验证
      this.$refs.form1.validate((valid) => {
        if (valid) {
          if (this.imgList.length === 0) {
            this.urlIMG = true
            return false
          }
          that.confirmTabLoading = true
          axios
            .put(`/manage/recruitSkin/edit`, {
              skinName: that.imgDetail.skin_name,
              id: that.imgDetail.id,
              skinPic:
                'response' in that.imgList[0]
                  ? that.imgList[0].response.message
                  : that.imgList[0].url.split('/')[that.imgList[0].url.split('/').length - 1],
              skinIntroduce: that.imgDetail.skin_introduce,
              price: that.imgDetail.price,
            })
            .then((res) => {
              if (res.result === '编辑成功!') {
                that.confirmTabLoading = false
                that.handleCancelTab()
                that.getTabsList()
              } else {
                that.$message.error(res.message)
              }
            })
            .catch((err) => {
              console.log(err)
            })
            .finally(() => {})
        } else {
          return false
        }
      })
    },

    // 关闭tab模态窗
    handleCancelTab() {
      this.tabVisible = false
    },

    async handlePreview(file) {
      this.bigImg = file.skin_pic
      this.previewVisible = true
    },
    handleChangedelete(info) {
      console.log(info.file)
      if (info.file.status === 'removed') {
        axios
          .delete(`/manage/recruitPicAbout/delete?id=${info.file.id}`)
          .then((res) => {
            if (res.result === '删除成功!') {
              this.getImageList()
            } else {
              that.$message.error(res.message)
            }
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {})
      }
    },

    // 获取列表
    getTabsList() {
      axios
        .get(`/manage/recruitSkin/getMyskin`)
        .then((res) => {
          console.log(res, 9876543)
          // 1 平台  2 学校
          this.type = res.result.type === '1' ? true : false
          if (res.result.type === '1') {
            this.skinList = res.result.list
            this.skinList.map((item) => {
              item.skin_pic = this.preview + item.skin_pic
            })
          } else if (res.result.type === '2') {
            this.skinList = res.result.list
            this.skinList.map((item) => {
              item.skin_pic = this.preview + item.skin_pic
            })
          }
          // 图片列表
        })
        .catch((err) => {
          console.log(err)
        })
        .finally(() => {})
    },
    // 详情
    detailList(item) {
      console.log(item, 888777)
      let aa = []
      this.tabVisible = true
      this.imgDetail = item
      aa.push({
        uid: -1,
        name: item.skin_pic,
        url: item.skin_pic,
      })
      this.imgList = aa
      this.urls = this.imgList[0].url
    },

    // 关闭图片模态窗
    handleCancelImage() {
      this.imgLists = []
      this.imageVisible = false
    },

    confirm(e, item) {
      //  1 平台
      if (e === 1) {
        axios
          .put(`/manage/recruitSkin/enable`, {
            id: item.id,
            orEnable: item.or_enable === '0' ? '1' : '0',
          })
          .then((res) => {
            console.log(res, 9876543)
            this.getTabsList()
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {})
      } else if (e === 2) {
        // 2 学校
        axios
          .get(`/manage/recruitSkin/UpdateSchoolSkin?skinId=${item.id}`)
          .then((res) => {
            console.log(res, 9876543)
            this.getTabsList()
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {})
      }
    },
    cancel(e, itme) {
      console.log(e)
      console.log(item)
      this.$message.error('Click on No')
    },
    // 保存皮肤
    handleOkImage() {
      console.log(this.imgLists)

      this.$refs.form.validate((valid) => {
        if (valid) {
          if (this.imgLists.length === 0) {
            this.urlIMG = true
            return false
          }
          this.confirmImageLoading = true
          axios
            .post(`/manage/recruitSkin/add`, {
              skinName: this.saveParm.skinName,
              skinPic: this.imgLists[0].response.message,
              skinIntroduce: this.saveParm.skinIntroduce,
              price: this.saveParm.price === undefined || this.saveParm.price === '' ? 0 : this.saveParm.price,
            })
            .then((res) => {
              if (res.result === '添加成功！') {
                this.confirmImageLoading = false
                this.handleCancelImage()
                this.getTabsList()
              } else {
                this.$message.error(res.message)
              }
            })
            .catch((err) => {
              console.log(err)
            })
            .finally(() => {})
        } else {
          return false
        }
      })
    },
    // 添加图片
    addImgs() {
      this.saveParm = {
        skinName: undefined,
        skinIntroduce: undefined,
        skinPic: undefined,
      }
      this.imgList = []
      this.imageVisible = true
    },
    handleChangeDetail(info) {
      console.log(info)
      this.urlIMG = false
      this.imgList = info.fileList
      if (info.file.status !== 'uploading') {
        console.log('正在上传')
      }
      if (info.file.status === 'done') {
        this.$message.success(`${info.file.name} 上传成功`)
        if (info.fileList.length == 2) {
          console.log(info.fileList)
          this.imgList = [
            {
              ...info.fileList[1],
              url: `${this.preview}${info.fileList[1].response.message}`,
            },
          ]
          this.$message.warning('一个版本只能上传一个文件')
          return false
        }
      } else if (info.file.status === 'error') {
        this.$message.error(`${info.file.name} 上传失败.`)
      } else if (info.file.status === 'removed') {
        this.$message.error(`${info.file.name} 删除成功.`)
        this.urlIMG = false
      }
    },
    handleChangeAdd(info) {
      this.urlIMG = false
      this.imgLists = info.fileList
      if (info.file.status !== 'uploading') {
        console.log('正在上传')
      }
      if (info.file.status === 'done') {
        this.$message.success(`${info.file.name} 上传成功`)
        if (info.fileList.length == 2) {
          console.log(info.fileList)
          this.imgLists = [
            {
              ...info.fileList[1],
              url: `${this.preview}${info.fileList[1].response.message}`,
            },
          ]
          this.$message.warning('一个版本只能上传一个文件')
          return false
        }
      } else if (info.file.status === 'error') {
        this.$message.error(`${info.file.name} 上传失败.`)
      } else if (info.file.status === 'removed') {
        this.$message.error(`${info.file.name} 删除成功.`)
        this.urlIMG = false
      }
    },
    handleCancel() {
      this.previewVisible = false
      this.bigImg = ''
    },
  },
}
</script>

<style lang="less" scoped>
.title {
  color: rgba(0, 0, 0, 0.85);
  font-size: 16px;
  font-weight: 500;
  margin-bottom: 16px;
}
</style>

<style scoped>
/* tile uploaded pictures */
.upload-list-inline >>> .ant-upload-list-item {
  float: left;
  width: 200px;
  margin-right: 8px;
}
.upload-list-inline >>> .ant-upload-animate-enter {
  animation-name: uploadAnimateInlineIn;
}
.upload-list-inline >>> .ant-upload-animate-leave {
  animation-name: uploadAnimateInlineOut;
}
</style>