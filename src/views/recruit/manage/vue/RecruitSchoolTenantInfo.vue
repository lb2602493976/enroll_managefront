<!-- 院校设置 基本信息-->
<template>
  <div>
    <a-card :bordered="false">
      <div style="marginBottom: '16px';display: flex; justify-content: flex-end;">
        <a-button type="primary"  @click="saveDetail">
          保存
        </a-button>
      </div>
      <detail-list title="展示信息">
        <detail-list-item term="登录背景" style="display: inline-table;">
          <a-upload
            :action="uploadAction"
            :headers="headers"
            :file-list="imglistBackGround"
            list-type="picture"
            @preview="handleUploadPreview"
            class="upload-list-inline"
            @change="handleChangeBackGround"
          >
            <a-button> <a-icon type="upload" /> 上传 </a-button>
          </a-upload>
<!--          <a-input style="width: 70%"></a-input>-->
        </detail-list-item>
        <detail-list-item term="学校logo">
          <a-upload
            :action="uploadAction"
            :headers="headers"
            :file-list="imglistLogo"
            :defaultFileList="imglistLogo"
            list-type="picture"
            class="upload-list-inline"
            @preview="handleUploadPreview"
            @change="handleChangeLogo"
          >
            <a-button> <a-icon type="upload" /> 上传 </a-button>
          </a-upload>
        </detail-list-item>
        <detail-list-item term="企业微信">
          <template v-if="ifWechatWork">
            <a-button  type="primary"  @click="bindWchat">
              未绑定
            </a-button>
          </template>
          <template v-else>
            <br>
            <img  alt="" style="width: 30%" :src="schoolDetail.WechatWork"  @click="handlePreview(schoolDetail.WechatWork)" />
          </template>

        </detail-list-item>
      </detail-list>
      <a-divider style="margin-bottom: 32px"/>
      <a-row :gutter="16">
        <a-col class="gutter-row" :span="12">
          <div class="gutter-box">
            <detail-list title="院校信息" >
              <detail-list-item term="院校名称" style="float: none;margin-left: 20px;">
                <a-input style="width: 300px;" v-model="schoolName"></a-input>
              </detail-list-item>
              <detail-list-item term="院校地址" style="float: none;margin-left: 20px;;width: 60%">{{schoolDetail.schoolAddress}}</detail-list-item>
<!--              <detail-list-item term="院校地址" style="float: none;margin-left: 20px;;width: 60%">陕西省西安市下北良陕西省西安市下北良陕西省西安市下北良陕西省西安市下北良陕西省西安市下北良</detail-list-item>-->
              <detail-list-item term="负责人" style="margin-left: 20px;">{{schoolDetail.schoolAdmin}}</detail-list-item>
              <detail-list-item term="负责人电话" style="float: none;margin-left: 20px;">{{schoolDetail.schoolAdminPhone}}</detail-list-item>
              <detail-list-item term="办学类型" style="margin-left: 20px;">{{schoolDetail.schoolType}}</detail-list-item>
              <!--        <detail-list-item term="有效期" style="margin-left: 20px;">{{schoolDetail.licenceValidity}}</detail-list-item>-->
              <!--        <detail-list-item term="办学许可证" style="float: none;margin-left: 20px;">-->
              <!--          <br>-->
              <!--          <img alt="" style="width: 100%" :src="schoolDetail.schoolLicence" @click="handlePreview(schoolDetail.schoolLicence)"/>-->
              <!--        </detail-list-item>-->
            </detail-list>
          </div>
        </a-col>
        <a-col class="gutter-row" :span="12" v-if="ifWechatWorkinput">
          <div class="gutter-box">
            <detail-list title="企业微信信息" >
              <detail-list-item term="通讯录Secret" style="float: none;margin-left: 20px;">
                <a-input style="width: 300px" v-model="qywx.addressListSecret"></a-input>
              </detail-list-item>
              <detail-list-item term=" 应  用  ID " style="float: none;margin-left: 20px;">
                <a-input style="width: 300px;margin-left: 27px" v-model="qywx.agentid"></a-input>
              </detail-list-item>
              <detail-list-item term=" 应 用 密 钥 " style="float: none;margin-left: 20px;">
                <a-input style="width: 300px;;margin-left: 8px" v-model="qywx.agentAppSecret"></a-input>
              </detail-list-item>
            </detail-list>
          </div>
        </a-col>
      </a-row>

      <a-divider style="margin-bottom: 32px"/>
      <detail-list title="推广信息" >
        <detail-list-item term="招生二维码" style="float: none;margin-left: 20px;">
          <span style="color: red;font-size: 12px">(请将该小程序二维码图片保存后放置于学校官网招生模块)</span>
          <br>
          <a :href="schoolDetail.downloadQr" download="logo.png" target="_blank">
            <img alt="" style="width: 100%" :src="schoolDetail.downloadQr" />
          </a>
        </detail-list-item>
      </detail-list>
    </a-card>
    <a-modal width="900px" :visible="previewVisible" :footer="null" @cancel="handleCancel">
      <img alt="" width="100%" :src="bigImg"/>
    </a-modal>
  </div>
</template>

<script>
  import DetailList from '@/components/tools/DetailList'
  const DetailListItem = DetailList.Item
  import { ACCESS_TOKEN } from "@/store/mutation-types"
  import { axios } from '@/utils/request'
  export default {
    components: {
      DetailList,
      DetailListItem,
    },
    data () {
      return {
        uploadAction:window._CONFIG['domianURL']+"/sys/common/upload",
        preview:window._CONFIG['domianURL']+"/sys/common/static/",
        codePreview:window._CONFIG['domianURL']+"/weixin/",
        headers:{
          'X-Access-Token' : this.$ls.get(ACCESS_TOKEN)
        },
        imglistBackGround : [],
        imglistLogo : [],
        schoolDetail:{},
        qywx:{},
        ifWechatWork:false,
        ifWechatWorkinput:false,
        schoolName:'',
        previewVisible:false,
        bigImg:'',
        urls:"OHR.GlassIgloos_ZH-CN8927574757_UHD_1622446650128.GlassIgloos_ZH-CN8927574757_UHD.jpg",
      }
    },
    created(){
      this.getAllDetail()
    },
    methods: {
      getAllDetail(){
        this.imglistBackGround = []
        this.imglistLogo = []
        axios
          .get(`/system/systemTenant/getSchoolTenantInfo`)
          .then((res) => {
            console.log(res,98765)
            this.schoolDetail = res.result.tenant
            // this.schoolDetail.schoolLicence = this.preview + res.result.tenant.schoolLicence
            this.schoolDetail.downloadQr = this.codePreview + res.result.base.downloadQr
            this.schoolName = res.result.tenant.name


            console.log(this.schoolDetail,'iiiiii')
            if(res.result.inputType === '1' || res.result.inputType === '2') {
              this.schoolDetail.WechatWork = res.result.base.WechatWork
            }

            if(res.result.inputType === '3' ){
              this.ifWechatWork = true
              this.ifWechatWorkinput = false
            }else if(res.result.inputType === '2' ){
              this.ifWechatWork = false
              this.ifWechatWorkinput = true
              this.qywx = {
                addressListSecret:'',
                agentid:'',
                agentAppSecret:'',
              }
            }else if(res.result.inputType === '1' && res.result.qywx ){
              this.ifWechatWork = false
              this.ifWechatWorkinput = true
              this.qywx = res.result.qywx
            }

            if(res.result.base.backImg !== null && res.result.base.backImg !== '' && res.result.base.backImg !== undefined){
              this.imglistBackGround.push({
                uid:-1,
                url:this.preview + res.result.base.backImg,
                name:res.result.base.backImg
              })
            }
            if(res.result.base.logo !== null && res.result.base.logo !== '' && res.result.base.logo !== undefined){
              this.imglistLogo.push({
                uid:-1,
                url:this.preview + res.result.base.logo,
                name:res.result.base.logo
              })
            }
            console.log(this.imglistLogo,'ooooooo')
            console.log(this.imglistBackGround,'yyyyyyy')
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {})
      },
      handleChangeBackGround(info) {
        console.log(info.fileList)
        this.imglistBackGround = info.fileList
        if (info.file.status !== 'uploading') {
          console.log('正在上传');
        }
        if (info.file.status === 'done') {
          this.$message.success(`${info.file.name} 上传成功`);
          if (info.fileList.length  == 2) {
            console.log(info.fileList)
            this.imglistBackGround = [{
              ...info.fileList[1],
              url: `${this.preview}${info.fileList[1].response.message}`
            }]
            this.$message.warning('一个版本只能上传一个文件');
            return false
          }
        } else if (info.file.status === 'error') {
          this.$message.error(`${info.file.name} 上传失败.`);
        }
      },
      handleChangeLogo(info) {
        console.log(info.fileList)
        this.imglistLogo = info.fileList
        if (info.file.status !== 'uploading') {
          console.log('正在上传');
        }
        if (info.file.status === 'done') {
          this.$message.success(`${info.file.name} 上传成功`);
          if (info.fileList.length  == 2) {
            console.log(info.fileList)
            this.imglistLogo = [{
              ...info.fileList[1],
              url: `${this.preview}${info.fileList[1].response.message}`
            }]
            this.$message.warning('一个版本只能上传一个文件');
            return false
          }
        } else if (info.file.status === 'error') {
          this.$message.error(`${info.file.name} 上传失败.`);
        }
      },
      handleCancel() {
        this.previewVisible = false;
      },
      saveDetail(){
        if(this.imglistBackGround.length<=0){
          this.$message.warning('请上传登录背景');
          return false
        }
        if(this.imglistLogo.length<=0){
          this.$message.warning('请上传学校logo');
          return false
        }
        if(this.schoolName === '' || this.schoolName === null || this.schoolName === undefined){
          this.$message.warning('请填写院校名称');
          return false
        }
        if(this.ifWechatWorkinput){
          if(this.qywx.addressListSecret === '' || this.qywx.addressListSecret === null || this.qywx.addressListSecret === undefined){
            this.$message.warning('请填写通讯录Secret');
            return false
          }
          if(this.qywx.agentid === '' || this.qywx.agentid === null || this.qywx.agentid === undefined){
            this.$message.warning('请填写应用ID');
            return false
          }
          if(this.qywx.agentAppSecret === '' || this.qywx.agentAppSecret === null || this.qywx.agentAppSecret === undefined){
            this.$message.warning('请填写应用密钥');
            return false
          }
          axios
            .put(`/system/systemTenant/editbasic`,{
              "name": this.schoolName,
              "siLogo": 'response' in this.imglistLogo[0] ? this.imglistLogo[0].response.message :this.imglistLogo[0].url.split('/')[this.imglistLogo[0].url.split('/').length-1],
              "siLoginbg": 'response' in this.imglistBackGround[0] ? this.imglistBackGround[0].response.message :this.imglistBackGround[0].url.split('/')[this.imglistBackGround[0].url.split('/').length-1],
              "AddressListSecret":this.qywx.addressListSecret,
              "Agentid":this.qywx.agentid,
              "AgentAppSecret":this.qywx.agentAppSecret,
            })
            .then((res) => {
              if(res.success){
                this.$message.success('提交成功');
                this.getAllDetail()
              }else {
                this.$message.error(res.message);
              }

            })
            .catch((err) => {
              console.log(err)
            })
            .finally(() => {})
        }else {
          axios
            .put(`/system/systemTenant/editbasic`,{
              "name": this.schoolName,
              "siLogo": 'response' in this.imglistLogo[0] ? this.imglistLogo[0].response.message :this.imglistLogo[0].url.split('/')[this.imglistLogo[0].url.split('/').length-1],
              "siLoginbg": 'response' in this.imglistBackGround[0] ? this.imglistBackGround[0].response.message :this.imglistBackGround[0].url.split('/')[this.imglistBackGround[0].url.split('/').length-1],
            })
            .then((res) => {
              if(res.success){
                this.$message.success('提交成功');
                this.getAllDetail()
              }else {
                this.$message.error(res.message);
              }

            })
            .catch((err) => {
              console.log(err)
            })
            .finally(() => {})
        }

      },

      async bindWchat(){
        await axios.get('/manage/qywxCorp/getAuthPage').then((res) => {
          console.log(res)
          window.location.href = res.result
        })
      },
      async handlePreview(file) {
        this.bigImg = file
        this.previewVisible = true;
      },
      async handleUploadPreview(file) {
        console.log(file)
        this.bigImg = file.url
        this.previewVisible = true;
      },
      handleDownLoad(a,file) {
        console.log(a)
        console.log(file)
        // this.bigImg = file
        // window.open(file)
        // this.previewVisible = true;
      },

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