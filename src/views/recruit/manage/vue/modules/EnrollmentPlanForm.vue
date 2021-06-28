<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="录取批次" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="admissionBatch">
              <a-input v-model="model.admissionBatch" placeholder="请输入录取批次"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="院系" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="dept">
              <a-input v-model="model.dept" placeholder="请输入院系"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="专业报考代码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="majorCode">
              <a-input v-model="model.majorCode" placeholder="请输入专业报考代码"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="专业名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="majorName">
              <a-input v-model="model.majorName" placeholder="请输入专业名称"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="招生科类" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="disciplineType">
              <a-input v-model="model.disciplineType" placeholder="请输入招生科类"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="年份" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="year">
              <a-input v-model="model.year" placeholder="请输入年份"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="省份" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="provinces">
              <a-input v-model="model.provinces" placeholder="请输入省份"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="招生人数" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="enrolment">
              <a-input-number v-model="model.enrolment" placeholder="请输入招生人数" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="招生类别" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="category">
              <a-input v-model="model.category" placeholder="请输入招生类别"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="学制" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="educational">
              <a-input v-model="model.educational" placeholder="请输入学制"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="学费" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="tuitionFees">
              <a-input-number v-model="model.tuitionFees" placeholder="请输入学费" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="租户id（学校id）" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="tenantId">
              <a-input v-model="model.tenantId" placeholder="请输入租户id（学校id）"  ></a-input>
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
    name: 'EnrollmentPlanForm',
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
        },
        url: {
          add: "/manage/enrollmentPlan/add",
          edit: "/manage/enrollmentPlan/edit",
          queryById: "/manage/enrollmentPlan/queryById"
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