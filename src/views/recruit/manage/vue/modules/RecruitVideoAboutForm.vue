<template>
  <a-spin :spinning="confirmLoading">
    <a-row :gutter="16">
      <a-col class="gutter-row" :span="14">
        <div class="gutter-box">
          <j-form-container :disabled="formDisabled">
            <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
              <a-row>
                <a-col :span="24">
                  <a-form-model-item label="标题" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="vaTitle">
                    <a-input v-model="model.vaTitle" placeholder="请输入标题（不超过20个字）"  :maxLength="20"></a-input>
                  </a-form-model-item>
                </a-col>
                <a-col :span="24">
                  <a-form-model-item label="说明" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="vaContent">
                    <j-editor v-model="model.vaContent" />
                  </a-form-model-item>
                </a-col>
                <a-col :span="24">
                  <a-form-model-item label="视频路径" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="vaUrl">
                    <j-upload v-model="model.vaUrl"   ></j-upload>
                  </a-form-model-item>
                </a-col>
                <a-col :span="24">
                  <a-form-model-item label="视频封面" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="vaCover">
                    <j-image-logo-upload isMultiple  v-model="model.vaCover" ></j-image-logo-upload>
                  </a-form-model-item>
                </a-col>
                <a-col :span="24">
                  <a-form-model-item label="所属院系" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="collegeId">
                    <j-dict-select-tag type="list" v-model="model.collegeId" dictCode="recruit_college_info,ci_name,id" placeholder="请选择所属院系" />
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
    name: 'RecruitVideoAboutForm',
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
        model:{
          vaContent:''
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
           vaTitle: [
              { required: true, message: '请输入标题!'},
           ],
           vaContent: [
              { required: true, message: '请输入说明!'},
           ],
           vaUrl: [
              { required: true, message: '请上传视频!'},
           ],
           collegeId: [
              { required: true, message: '请选择所属院系!'},
           ],
           vaCover: [
              { required: true, message: '请上传视频封面!'},
           ],
        },
        url: {
          add: "/manage/recruitVideoAbout/add",
          edit: "/manage/recruitVideoAbout/edit",
          queryById: "/manage/recruitVideoAbout/queryById"
        }
      }
    },
    watch: {
      model: {
        handler(newName) {
          let a = newName.vaContent
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
    },
    methods: {
      add () {
        this.edit(this.modelDefault);
      },
      edit (record) {
        this.model = Object.assign({}, record);
        this.visible = true;
      },
      submitForm () {
        this.model.vaSize = localStorage.getItem("fileSize")
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