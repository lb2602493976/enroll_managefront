<template>
  <a-spin :spinning="confirmLoading">
    <a-row :gutter="16">
      <a-col class="gutter-row" :span="14">
        <div class="gutter-box">
          <j-form-container :disabled="formDisabled">
            <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
              <a-row>
                <a-col :span="24">
                  <a-form-model-item label="院系名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="ciName">
                    <a-input v-model="model.ciName" placeholder="请输入院系名称（不超过20个字）"  :maxLength="20"></a-input>
                  </a-form-model-item>
                </a-col>
                <a-col :span="24">
                  <a-form-model-item label="院系icon图" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="icon">
                    <!-- <a-input v-model="model.icon" placeholder="请输入院系名称（不超过20个字）"  :maxLength="20"></a-input> -->
                    <!-- <j-image-logo-upload></j-image-logo-upload> -->
                    <j-image-logo-upload isMultiple  v-model="model.icon"></j-image-logo-upload>

                  </a-form-model-item>
                </a-col>
                <a-col :span="24">
                  <a-form-model-item label="院系介绍" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="ciContent">
                    <j-editor v-model="model.ciContent" />
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
import JImageLogoUpload from '../../../../../components/jeecg/JImageLogoUpload.vue'

  export default {
    name: 'RecruitCollegeInfoForm',
    components: {
        JImageLogoUpload
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
          let a = newName.ciContent
          document.getElementsByClassName('aa')[0].innerHTML = a
        },
        deep: true
      }
    },
    data () {
      return {
        model:{
          ciContent:''
         },
        htm:'',
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
           ciName: [
              { required: true, message: '请输入院系名称!'},
           ],
           ciContent: [
              { required: true, message: '请输入院系介绍!'},
           ],
           icon: [
              { required: true, message: '请选择icon!'},
           ],
        },
        url: {
          add: "/manage/recruitCollegeInfo/add",
          edit: "/manage/recruitCollegeInfo/edit",
          queryById: "/manage/recruitCollegeInfo/queryById"
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