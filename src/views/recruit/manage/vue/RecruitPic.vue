<!--宣传图片-->
<template>
  <div>
    <a-card :bordered="false">
      <detail-list title="展示内容" >
        <div style="marginBottom: '16px';display: flex; justify-content: flex-end;">
          <a-button type="primary" style="margin: 5px" @click="addImgs">
            添加图片
          </a-button>
          <a-button v-if="targetKey !== '1'" type="primary" style="margin: 5px" @click="deleteImgs()">
            删除所有
          </a-button>
          <a-button v-if="targetKey !== '1'" type="primary" style="margin: 5px" @click="add('',2)">
            修改标签
          </a-button>
        </div>
        <a-tabs default-active-key="1" tab-position="left" type="editable-card" @edit="onEdit" @change="change">
          <template v-for="(item,index) in tabList"  >
            <a-tab-pane :key=item.id :tab=item.ptName  :closable='item.id !== "1"' >
              <div v-if="item.id === '1'">
                <div v-for="(items,indexImg) in allPicture" :key="indexImg">
                  <h2>
                    {{items.ptName}}
                    <!-- {{items.name }} -->
                  </h2>
                  <div class="clearfix">
                    <a-upload
                      list-type="picture"
                      :action="items.picList.url"
                      :file-list="items.picList"
                      class="upload-list-inline"
                      @preview="handlePreview"
                      @change="handleChangedelete"
                      
                    >
                    </a-upload>
                    <a-modal :visible="previewVisible" :footer="null" @cancel="handleCancel">
                      <img alt="9876544567" style="width: 100%" :src="previewImage" />
                    </a-modal>
                  </div>
                </div>
              </div>
              <div v-else>
                <div v-for="(items,indexImg) in allPicture" :key="indexImg">
                  <h2>
                    {{items.ptName}}
                  </h2>
                  <div class="clearfix">
                    <a-upload
                      list-type="picture"
                      :file-list="items.picList"
                      class="upload-list-inline"
                      @preview="handlePreview"
                      @change="handleChangedelete"
                    >
                    </a-upload>
                    <a-modal :visible="previewVisible" :footer="null" @cancel="handleCancel">
                      <img alt="9876544567" style="width: 100%" :src="previewImage" />
                    </a-modal>
                  </div>
                </div>
              </div>
            </a-tab-pane>
          </template>
        </a-tabs>
      </detail-list>
    </a-card>

    <a-modal
      :title="titleTab"
      :visible="tabVisible"
      :confirm-loading="confirmTabLoading"
      @ok="handleOkTab"
      @cancel="handleCancelTab"
    >
      <a-input v-model="ptName" placeholder="请输入标签名称" :maxLength="10" ></a-input>
    </a-modal>

    <a-modal
      destroyOnClose
      title="添加图片"
      :width=1200
      :visible="imageVisible"
      :confirm-loading="confirmImageLoading"
      @ok="handleOkImage"
      @cancel="handleCancelImage"
    >
      <a-form-model :model="saveParm">
        <a-form-model-item
          label="拍摄时间"
          :label-col="formItemLayout.labelCol"
          :wrapper-col="formItemLayout.wrapperCol"
        >
          <a-date-picker v-model="saveParm.picTime" placeholder="请输入" style="width: 100%" :format="dateFormat"/>
        </a-form-model-item>
        <a-form-model-item
          label="标签"
          :label-col="formItemLayout.labelCol"
          :wrapper-col="formItemLayout.wrapperCol"
        >
          <a-select v-model="saveParm.picType" style="width: 100%"  placeholder="请选择" >
            <a-select-option v-for="(item,i) in tabList" :key="item.id"  :disabled="item.id ==='1'" :value="item.id">
              {{item.ptName}}
            </a-select-option>
          </a-select>
        </a-form-model-item>
        <a-form-model-item
          label="图片路径"
          :label-col="formItemLayout.labelCol"
          :wrapper-col="formItemLayout.wrapperCol"
        >
          <a-upload
            :action="uploadAction"
            :headers="headers"
            :default-file-list="imgList"
            list-type="picture"
            class="upload-list-inline"
            @change="handleChange"
          >
            <a-button> <a-icon type="upload" /> 上传 </a-button>
          </a-upload>
        </a-form-model-item>
      </a-form-model>
    </a-modal>
  </div>
</template>

<script>
  import moment from 'moment'
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
    data () {
      return {
        uploadAction:window._CONFIG['domianURL']+"/upload/uploadPic",
        preview:window._CONFIG['domianURL']+"/sys/common/static/",
        headers:{
          'X-Access-Token' : this.$ls.get(ACCESS_TOKEN)
        },
        dateFormat: 'YYYY-MM-DD',
        tabList:[], // 标签列表
        ptName:'', // 新增标签
        tabVisible:false, // 新增标签模态窗
        imageVisible:false, // 新增图片模态窗
        confirmImageLoading: false,// 新增图片加载动画
        confirmTabLoading: false,// 新增标签加载动画
        targetKey: '1',// 默认标签
        titleTab: '',// 默认标签
        stus: '',// 默认标签
        fileList: [],
        previewVisible: false,
        previewImage: '',
        formItemLayout: {
          labelCol: { span: 6 },
          wrapperCol: { span: 14 },
        },
        allPicture:[],
        uploadFileList:[], // 上传图片
        imgList : [],
        showPic : false,
        saveParm:{
          picTime:undefined,
          picUrl:[],
          picType:undefined
        }
      }
    },
    created(){
      this.getTabsList()
      // this.getImageList()
    },
    methods: {
      // 编辑标签
      onEdit(targetKey, action) {
        this[action](targetKey,1);
        this.targetKey = targetKey
      },
      // 改变标签
      change(targetKey){
        this.targetKey = targetKey
        this.getImageList()
      },
      // 获取tablist
      getTabsList(){
        axios
          .get(`/manage/recruitPictureType/getPictureTypeList`)
          .then((res) => {
            this.tabList = res.result
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {})
      },
      // 添加标签
      add(targetKey,stus) {
        if(stus === 2){
          this.stus = 2
          this.titleTab = '修改标签'
          this.tabVisible=true
          const a = this.tabList.filter(item => item.id === this.targetKey)
          this.ptName = a[0].ptName
        }else if(stus === 1){
          this.stus = 1
          this.titleTab = '添加标签'
          this.tabVisible=true
        }
      },
      // 删除标签
      remove(targetKey) {
        const that = this;
        axios
          .delete(`/manage/recruitPicAbout/deletePicAboutListByType?type=${targetKey}&state=2`)
          .then((res) => {
            if(res.result === "删除成功！"){
              that.$message.success(res.message);
              that.getTabsList()
            }else {
              that.$message.error(res.message);
            }
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {})
      },
      // 根据id获取图片
      getImageList(){
        axios
          .get(`/manage/recruitPicAbout/getRecruitPicAboutList/${this.targetKey}`)
          .then((res) => {
            console.log(res)
            const a = []
            res.result.map((item)=>{
              if(item.picList.length > 0){
                const aa = []
                item.picList.map((items,index)=>{
                  console.log(items,'ssssss')
                  aa.push({
                    uid: -`${index}`,
                    id: items.id,
                    // name: `${items.picTime} -${items.picUrl}`,
                    // url: `${this.preview}${items.picUrl}`,
                    name: `${items.createTime}`,
                    url: `${items.picUrl}`,
                  })
                })
                a.push({
                  ptName:item.ptName,
                  id:item.id,
                  picList:aa
                })
              } else {
                a.push({
                  ptName:item.ptName,
                  id:item.id,
                  picList:[]
                })
              }
            })
            console.log(a,'picur')
            // this.allPicture = a
            this.allPicture = a
             console.log(this.allPicture,'picur21312312')
            
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {})
      },
      // 删除单个图片
      deleteImg(){

      },
      // 删除图片
      deleteImgs(){
        const that = this;
        axios
          .delete(`/manage/recruitPicAbout/deletePicAboutListByType?type=${that.targetKey}&state=1`)
          .then((res) => {
            if(res.result === "删除成功！"){
              that.$message.success(res.message);
              that.getTabsList()
              that.getImageList()
              this.handleCancelImage()
            }else {
              that.$message.error(res.message);
            }
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {})
      },
      // 添加图片
      addImgs(){
        this.showPic = true
        if(this.showPic){
          this.saveParm = {
            picTime:undefined,
            picUrl:[],
            picType:undefined
          }
          this.uploadFileList = []
          this.imgList = []
          this.imageVisible = true
        }

      },
      // 保存图片
      saveImage(){

      },
      // 保存tab
      handleOkTab(){
        this.confirmLoading = true;
        const that = this;
        if(this.ptName === ''){
          return
        }
        if(that.stus === 2){
          axios
            .put(`/manage/recruitPictureType/edit`,{
              ptName:this.ptName,
              id:this.targetKey,
            })
            .then((res) => {
              if(res.result === '编辑成功!'){
                this.confirmLoading = false;
                that.$message.success(res.message);
                that.handleCancelTab()
                that.getTabsList()
              }else {
                that.$message.error(res.message);
              }
            })
            .catch((err) => {
              console.log(err)
            })
            .finally(() => {})
        }else if(that.stus === 1){
          axios
            .post(`/manage/recruitPictureType/add`,{
              ptName:this.ptName
            })
            .then((res) => {
              if(res.result === '添加成功！'){
                this.confirmLoading = false;
                that.$message.success(res.message);
                that.handleCancelTab()
                that.getTabsList()
              }else {
                that.$message.error(res.message);
              }
            })
            .catch((err) => {
              console.log(err)
            })
            .finally(() => {})
        }

      },
      // 保存image
      handleOkImage(){
        axios
          .post(`/manage/recruitPicAbout/add`,{
            picTime:moment(this.saveParm.picTime).format('YYYY-MM-DD'),
            picUrl:this.uploadFileList,
            picType:this.saveParm.picType,
          })
          .then((res) => {
            if(res.result === "添加成功！"){
              this.handleCancelImage()
              this.getTabsList()
            }else {
              that.$message.error(res.message);
            }
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {})
      },
      // 关闭tab模态窗
      handleCancelTab(){
        this.tabVisible = false
        this.ptName = ''
      },
      // 关闭图片模态窗
      handleCancelImage(){
        this.saveParm = {
          picTime:undefined,
          picUrl:[],
          picType:undefined
        }
        this.uploadFileList = []
        this.imgList = []
        this.imageVisible = false
        this.showPic = false
      },

      handleCancel() {
        this.previewVisible = false;
      },
      async handlePreview(file) {
        // console.log(file,'321312312312312312312312')
        if (!file.url && !file.preview) {
          file.preview = await getBase64(file.originFileObj);
        }
        this.previewImage = file.url || file.preview;
        // console.log(this.previewImage ,'6321312312312332131212312312312')
        this.previewVisible = true;
      },
      handleChange(info) {
        let fileList = info.fileList
        // if (info.file.status !== 'uploading') {
        //   console.log('正在上传');
        //   return;
        // }
        // if (info.file.status === 'done') {
        //   if(info.file.response.success){
        //     fileList = fileList.map((file) => {
        //       if (file.response) {
        //         file.url = file.response.message;
        //       }
        //       return file;
        //     });
        //   }
        //   this.imgList = fileList
        //   this.uploadFileList.push(info.file.response.message)
        //   this.$message.success(`${info.file.name} 上传成功`);
        // } else if (info.file.status === 'error') {
        //   this.$message.error(`${info.file.name} 上传失败.`);
        // }
        if (info.file.status === 'done') {
          if(info.file.response){
            fileList = fileList.map((file) => {
              // console.log(file,'filelist->item')
              if (file.response) {
                file.response.url = file.response.url;
              }
              // console.log(file,'filelist->item')
              return file;
            });
          }
          this.imgList = fileList
          this.uploadFileList.push(info.file.response.url)
          this.$message.success(`${info.file.name} 上传成功`);
        } else if (info.file.status === 'error') {
          this.$message.error(`${info.file.name} 上传失败.`);
        }
      },
      handleChangedelete(info){
        // console.log(info.file)
        if(info.file.status === 'removed'){
          axios
            .delete(`/manage/recruitPicAbout/delete?id=${info.file.id}`)
            .then((res) => {
              if(res.result === "删除成功!"){
                this.getImageList()
              }else {
                that.$message.error(res.message);
              }
            })
            .catch((err) => {
              console.log(err)
            })
            .finally(() => {})
        }
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