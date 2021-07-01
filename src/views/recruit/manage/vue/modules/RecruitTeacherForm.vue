<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
              <a-input v-model="model.name" placeholder="请输入姓名"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="部门" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="dept">
              <a-input v-model="model.dept" placeholder="请输入部门"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="手机号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="phone">
              <a-input v-model="model.phone" placeholder="请输入手机号"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="负责区域" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="area">
              <a-input v-model="model.area" placeholder="请输入负责区域"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="微信url" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="wechatUrl">
              <!-- <a-input v-model="model.wechatUrl" placeholder="请输入微信url"  ></a-input> -->
              <!-- <j-image-upload isMultiple v-model="model.wechatUrl"></j-image-upload> -->
              <a-upload
                style="width: 128px;height: 128px;"
                name="file"
                list-type="picture-card"
                v-model="model.wechatUrl"
                class="avatar-uploader"
                :show-upload-list="false"
                :action="`${BASE_API}/upload/uploadPic`"
                @change="handleChange"
                :before-upload="beforeUpload"
              >
              
                <img style="width: 128px;height: 128px;" v-if="model.wechatUrl" :src="model.wechatUrl" alt="avatar" />
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
            <a-form-model-item label="照片url" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="photoUrl">
              <!-- <a-input v-model="model.photoUrl" placeholder="请输入照片url"  ></a-input> -->
              <!-- <j-image-upload isMultiple v-model="model.photoUrl"></j-image-upload> -->
              <a-upload
                style="width: 128px;height: 128px;"
                name="file"
                list-type="picture-card"
                v-model="model.photoUrl"
                class="avatar-uploader"
                :show-upload-list="false"
                :action="`${BASE_API}/upload/uploadPic`"
                @change="handleChange1"
                :before-upload="beforeUpload1"
              >
              
                <img style="width: 128px;height: 128px;" v-if="model.photoUrl" :src="model.photoUrl" alt="avatar" />
                <div v-else>
                  <a-icon :type="loading1 ? 'loading' : 'plus'" />
                  <div class="ant-upload-text">
                    Upload
                  </div>
                </div>
              </a-upload>
            </a-form-model-item>
          </a-col>
          <!-- <a-col :span="24">
            <a-form-model-item label="租户id（学校id）" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="tenantId">
              <a-input v-model="model.tenantId" placeholder="请输入租户id（学校id）"  ></a-input>
            </a-form-model-item>
          </a-col> -->
        </a-row>
      </a-form-model>
    </j-form-container>
  </a-spin>
</template>

<script>

  import { httpAction, getAction } from '@/api/manage'
  import { validateDuplicateValue } from '@/utils/util'

  export default {
    name: 'RecruitTeacherForm',
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
        loading1 : false,
        model:{
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
        },
        url: {
          add: "/manage/recruitTeacher/add",
          edit: "/manage/recruitTeacher/edit",
          queryById: "/manage/recruitTeacher/queryById"
        }
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
    },
    methods: {
      //微信
       handleChange(info) {
        if (info.file.status === 'uploading') {
          this.loading = true;
          return;
        }
        if (info.file.status === 'done') {
           console.log(info.file,'info')
          this.model.wechatUrl=info.file.response.url
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
      
      //图片
       handleChange1(info) {
        if (info.file.status === 'uploading') {
          this.loading1 = true;
          return;
        }
        if (info.file.status === 'done') {
           console.log(info.file,'info')
          this.model.photoUrl=info.file.response.url
        }
      },
      // 限制图片大小
      beforeUpload1(file) {
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