<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="学校名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="name">
              <a-input v-model="model.name" placeholder="请输入学校名称（不超过30个字）" :maxLength="30" ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="办学类型" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="schoolType">
              <j-dict-select-tag type="list" v-model="model.schoolType" dictCode="school_type" placeholder="请选择办学类型" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="学校地址" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="schoolAddress">
              <a-input v-model="model.schoolAddress" placeholder="请输入学校地址（不超过100个字）" :maxLength="100" ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="管理员姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="schoolAdmin">
              <a-input v-model="model.schoolAdmin" placeholder="请输入管理员姓名（不超过10个字）"  :maxLength="10"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="管理员电话" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="schoolAdminPhone">
              <a-input v-model="model.schoolAdminPhone" placeholder="请输入管理员电话"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="域名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="schoolDomain">
              <a-input v-model="model.schoolDomain" placeholder="请输入域名（可填写学校首字母，不超过20个字）" addon-after=".kdgxyun.cn" :maxLength="20" :disabled="model.id"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="版本" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="fvId">
              <j-dict-select-tag type="list" v-model="model.fvId" dictCode="recruit_function_version,version_name,id" placeholder="请选择版本" />
            </a-form-model-item>
          </a-col>
        </a-row>
      </a-form-model>
    </j-form-container>
  </a-spin>
</template>

<script>

  import { httpAction, getAction } from '@/api/manage'
  import { validateDuplicateValue } from '@/utils/util'

  export default {
    name: 'SystemTenantForm',
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
           name: [
              { required: true, message: '请输入学校名称!'},
           ],
           schoolType: [
              { required: true, message: '请选择办学类型!'},
           ],
           schoolAdmin: [
              { required: true, message: '请输入管理员姓名!'},
           ],
           schoolAdminPhone: [
              { required: true, message: '请输入手机号码!'},
              { pattern: /^1[3456789]\d{9}$/, message: '请输入正确的手机号码!'},
           ],
           schoolDomain: [
              { required: true, message: '请输入域名!'},
              { pattern: /^[A-Za-z]+$/, message: '请输入正确的域名!'},
           ],
           fvId: [
              { required: true, message: '请选择版本!'},
           ],
        },
        url: {
          add: "/system/systemTenant/add",
          edit: "/system/systemTenant/edit",
          queryById: "/system/systemTenant/queryById"
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