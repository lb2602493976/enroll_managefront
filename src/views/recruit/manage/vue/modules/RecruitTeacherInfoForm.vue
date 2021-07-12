<template>
  <a-spin :spinning="confirmLoading">
    <a-row :gutter="16">
      <a-col class="gutter-row" :span="14">
        <div class="gutter-box">
          <j-form-container :disabled="formDisabled">
            <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
              <a-row>
                <a-col :span="24">
                  <a-form-model-item label="排序" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="sort">
                    <a-input v-model="model.sort" placeholder="请输入排序" :maxLength="20" ></a-input>
                  </a-form-model-item>
                </a-col>
                <a-col :span="24">
                  <a-form-model-item label="名师姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="tiName">
                    <a-input v-model="model.tiName" placeholder="请输入名师姓名（不超过10个字）" :maxLength="10" ></a-input>
                  </a-form-model-item>
                </a-col>
                <a-col :span="24">
                  <a-form-model-item label="所属院系" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="collegeId">
                    <j-dict-select-tag type="list" v-model="model.collegeId" dictCode="recruit_college_info,ci_name,id" placeholder="请选择所属院系" />
                  </a-form-model-item>
                </a-col>
                <a-col :span="24">
                  <a-form-model-item label="名师类型" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="tiType">
                    <a-input v-model="model.tiType" placeholder="请输入名师类型（不超过20个字）" :maxLength="20" ></a-input>
                  </a-form-model-item>
                </a-col>
                <a-col :span="24">
                  <a-form-model-item label="名师介绍" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="tiContent">
                    <!-- <j-editor v-model="model.tiContent" /> -->
                    <a-input v-model="model.tiContent" placeholder="请输入名师介绍"  ></a-input>
                  </a-form-model-item>
                </a-col>
                
                <a-col :span="24">
                  <a-form-model-item label="封面照片" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="tiPhoto">
                    <!--              <j-image-upload isMultiple  v-model="model.tiPhoto" ></j-image-upload>-->
                    <!-- <j-image-logo-upload isMultiple  v-model="model.tiPhoto" ></j-image-logo-upload> -->
                    <a-upload
                        style="width: 128px;height: 128px;"
                        name="file"
                        list-type="picture-card"
                        v-model="model.tiPhoto"
                        class="avatar-uploader"
                        :show-upload-list="false"
                        :action="`${BASE_API}/upload/uploadPic`"
                        @change="handleChange"
                        :before-upload="beforeUpload"
                      >
                      
                        <img style="width: 128px;height: 128px;" v-if="model.tiPhoto" :src="model.tiPhoto" alt="avatar" />
                        <div v-else>
                          <a-icon :type="loading ? 'loading' : 'plus'" />
                          <div class="ant-upload-text">
                            Upload
                          </div>
                        </div>
                      </a-upload>
                  </a-form-model-item>
                </a-col>
              </a-row>
            </a-form-model>
          </j-form-container>
        </div>
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
    </a-row>
  </a-spin>
</template>

<script>

  import { httpAction, getAction } from '@/api/manage'
  import { validateDuplicateValue } from '@/utils/util'

  export default {
    name: 'RecruitTeacherInfoForm',
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
    watch: {
      model: {
        handler(newName) {
          let a = newName.tiContent
          document.getElementsByClassName('aa')[0].innerHTML = a
        },
        deep: true
      }
    },
    data () {
      return {
        BASE_API:window._CONFIG['domianURL'],
        loading : false,
        model:{
          tiContent:'',
          sort:''
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
           tiName: [
              { required: true, message: '请输入名师姓名!'},
           ],
           collegeId: [
              { required: true, message: '请输入所属院系!'},
           ],
           tiContent: [
              { required: true, message: '请输入名师介绍!'},
           ],
           tiType: [
              { required: true, message: '请输入名师类型!'},
           ],
           tiPhoto: [
              { required: true, message: '请输入封面照片!'},
           ],
        },
        url: {
          add: "/manage/recruitTeacherInfo/add",
          edit: "/manage/recruitTeacherInfo/edit",
          queryById: "/manage/recruitTeacherInfo/queryById"
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
       handleChange(info) {
        if (info.file.status === 'uploading') {
          this.loading = true;
          return;
        }
        if (info.file.status === 'done') {
           console.log(info.file,'info')
          this.model.tiPhoto=info.file.response.url
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
        // console.log(record,'record')
        
        // this.model = Object.assign({}, record);
        // console.log(model1,'mode1')
       
        this.model ={...record}
        // console.log(this.model,'model')
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
            httpAction(httpurl,{...this.model,sort:parseInt(this.model.sort)},method).then((res)=>{
              console.log(this.model,'model111')
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