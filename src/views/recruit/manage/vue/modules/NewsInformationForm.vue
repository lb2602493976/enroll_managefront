<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="图标" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="icon">
              <!-- <j-image-logo-upload isMultiple  v-model="model.icon"></j-image-logo-upload> -->
              <a-upload
                style="width: 128px;height: 128px;"
                name="file"
                list-type="picture-card"
                v-model="model.icon"
                class="avatar-uploader"
                :show-upload-list="false"
                :action="`${BASE_API}/upload/uploadPic`"
                @change="handleChange"
                :before-upload="beforeUpload"
              >
              
                <img style="width: 128px;height: 128px;" v-if="model.icon" :src="model.icon" alt="avatar" />
                <div v-else>
                  <a-icon :type="loading ? 'loading' : 'plus'" />
                  <div class="ant-upload-text">
                    Upload
                  </div>
                </div>
              </a-upload>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="新闻事件" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="pressTime">
              <j-date placeholder="请选择新闻时间" v-model="model.pressTime"  style="width: 100%" />
            </a-form-model-item>
          </a-col>

          <a-col :span="24" >
            <a-form-model-item label="类型" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="type">
              <j-dict-select-tag type="list" v-model="model.type" dictCode="new_types" placeholder="请选择新闻资讯模块" />
            </a-form-model-item>
          </a-col>

          <a-col :span="24" >
            <a-form-model-item label="标题" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="title">
              <!-- <j-date placeholder="请输入标题" v-model="model.title"  style="width: 100%" /> -->
              <a-input v-model="model.title" placeholder="请输入标题"  ></a-input>
              <!-- <j-dict-select-tag type="list" v-model="model.title" dictCode="new_types" placeholder="请选择新闻资讯模块" /> -->
            </a-form-model-item>
          </a-col>

          <!-- <a-col :span="24">
            <a-form-model-item label="跳转公众号链接" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="content">
              <a-input v-model="model.content" placeholder="请输入跳转公众号链接"></a-input>
            </a-form-model-item>
          </a-col> -->
          
          <a-col :span="14" >
            <a-form-model-item label="模块内容" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="content">
              <j-editor v-model="model.content" />
            </a-form-model-item>
          </a-col>

          <a-col class="gutter-row" :span="10">
            <div class="gutter-box">
              <div style="border: 1px solid black;width: 414px;height: 600px;position: relative;">
                <img  style="width: 100%" src="../../../../../assets/mob.png"/>
                <div class="aa" style="position: absolute;top: 79px;bottom: 0;overflow: auto;width: 410px;padding: 5px 20px;">
                </div>
              </div>
            </div>
          </a-col>
          <!-- <a-col :span="24" v-if="showCol">
            <a-form-model-item label="附件" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="cmFile">
              <j-upload v-model="model.cmFile"   ></j-upload>
            </a-form-model-item>
          </a-col> -->
          
        </a-row>
        
      </a-form-model>
    </j-form-container>
    <a-row :gutter="16" >
      <!-- <a-col class="gutter-row" :span="14">
        <div class="gutter-box">
          <j-form-container :disabled="formDisabled">
            <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
              <a-row>
                <a-col :span="24">
                  <a-form-model-item label="图标" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="moduleIcon">
                    <j-image-logo-upload isMultiple  v-model="model.moduleIcon"></j-image-logo-upload>
                  </a-form-model-item>
                </a-col>
                <a-col :span="24">
                  <a-form-model-item label="模块名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="moduleName">
                    <a-input v-model="model.moduleName" placeholder="请输入模块名称（不超过4个字）" :maxLength="4" ></a-input>
                  </a-form-model-item>
                </a-col>
                <a-col :span="24" v-if="showCol">
                  <a-form-model-item label="标题" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="title">
                    <a-input v-model="model.title" placeholder="请输入标题（不超过50个字）" :maxLength="50" ></a-input>
                  </a-form-model-item>
                </a-col>
                <a-col :span="24" v-if="showCol">
                  <a-form-model-item label="模块内容" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="content">
                    <j-editor v-model="model.content" />
                  </a-form-model-item>
                </a-col>
              </a-row>
            </a-form-model>
          </j-form-container>
        </div>
      </a-col> -->
      
    </a-row>
  </a-spin>
</template>

<script>

  import { httpAction, getAction } from '@/api/manage'
  import { validateDuplicateValue } from '@/utils/util'

  export default {
    name: 'RecruitModuleForm',
    components: {
    },
    props: {
      //表单禁用
      disabled: {
        type: Boolean,
        default: false,
        required: false
      }
    },
    data () {
      return {
        BASE_API:window._CONFIG['domianURL'],
        loading : false,
        model:{
          content:''
         },
        labelCol: {
          xs: { span: 24 },
          sm: { span: 5 },
        },
        wrapperCol: {
          xs: { span: 24 },
          sm: { span: 16 },
        },
        confirmLoading: false,
        validatorRules: {
           pressTime: [{required: true, message: '新闻时间不能为空！',trigger: 'blur' }],
           type: [{required: true, message: '类型不能为空！',trigger: 'blur' }],
           content: [{required: true, message: '内容不能为空！',trigger: 'blur' }],
           title: [{required: true, message: '标题不能为空！',trigger: 'blur' }],
           icon: [{required: true, message: '图标不能为空！',trigger: 'blur' }],
          //  titl
          //  tenantId: [{required: true, message: '验证码不能为空！',trigger: 'blur' }],
          //  cmFile: [
          //     { required: true, message: '请输入附件!'},
          //  ],
        },
        url: {
          add: "/manage1/newsInformation/add",
          edit: "/manage1/newsInformation/edit",
          queryById: "/manage1/newsInformation/queryById"
        },
        // showCol:true,
      }
    },
    watch: {
      model: {
        handler(newName) {
          let a = newName.content
          document.getElementsByClassName('aa')[0].innerHTML = a
        },
        deep: true
      }
    },
    computed: {
      formDisabled(){
        return this.disabled
      },
    },
    created () {
       //备份model原始值
      this.modelDefault = JSON.parse(JSON.stringify(this.model));
      console.log(this.model,98765)
    },
    methods: {
      handleChange(info) {
        if (info.file.status === 'uploading') {
          this.loading = true;
          return;
        }
        if (info.file.status === 'done') {
           console.log(info.file,'info')
          this.model.icon=info.file.response.url
        }
      },
      // 限制图片大小
      beforeUpload(file) {
        const isJpgOrPng = file.type === 'image/jpeg' || file.type === 'image/png';
        if (!isJpgOrPng) {
          this.$message.error('You can only upload JPG file!');
        }
        const isLt2M = file.size / 1024 / 1024 < 2;
        console.log(isLt2M,'2M')
        if (!isLt2M) {
          this.$message.error('Image must smaller than 2MB!');
        }
        return isJpgOrPng && isLt2M;
      },
      add () {
        this.edit(this.modelDefault);
      },
      edit (record) {
        //console.log(record)
        // if(record.moduleType==1){
        //   this.showCol = false
        // }else{
        //   this.showCol = true
        // }
        this.model = Object.assign({}, record);
        this.visible = true;
      },
      submitForm () {
        const that = this;
        // 触发表单验证
        this.$refs.form.validate(valid => {
          if (valid) {
            that.confirmLoading = true;
            let httpurl = '';
            let method = '';
            if(!this.model.id){
              httpurl+=this.url.add;
              method = 'post';
            }else{
              httpurl+=this.url.edit;
               method = 'put';
            }
            httpAction(httpurl,this.model,method).then((res)=>{
              if(res.success){
                that.$message.success(res.message);
                that.$emit('ok');
              }else{
                that.$message.warning(res.message);
              }
            }).finally(() => {
              that.confirmLoading = false;
            })
          }

        })
      },
    }
  }
</script>