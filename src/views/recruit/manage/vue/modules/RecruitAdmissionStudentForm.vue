<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <!-- <a-col :span="24">
            <a-form-model-item label="租户id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="tenantId">
              <a-input-number v-model="model.tenantId" placeholder="请输入租户id" style="width: 100%" />
            </a-form-model-item>
          </a-col> -->
          <a-col :span="24">
            <a-form-model-item label="学生姓名" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="stuName">
              <a-input v-model="model.stuName" placeholder="请输入学生姓名"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="性别" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="gender">
              <a-input-number v-model="model.gender" placeholder="请输入性别" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="民族" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="nation">
              <a-input v-model="model.nation" placeholder="请输入民族"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="头像" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="headPortrait">
              <a-input v-model="model.headPortrait" placeholder="请输入头像"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="政治面貌" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="politicalStatus">
              <a-input-number v-model="model.politicalStatus" placeholder="请输入政治面貌" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="身份证号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="idCard">
              <a-input v-model="model.idCard" placeholder="请输入身份证号"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="手机号码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="phone">
              <a-input v-model="model.phone" placeholder="请输入手机号码"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="所在地区" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="region">
              <a-input v-model="model.region" placeholder="请输入所在地区"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="地区编码" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="regionCode">
              <a-input v-model="model.regionCode" placeholder="请输入地区编码"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="家庭住址" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="address">
              <a-input v-model="model.address" placeholder="请输入家庭住址"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="毕业学校" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="graduatedSchool">
              <a-input v-model="model.graduatedSchool" placeholder="请输入毕业学校"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="准考证号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="examinationNumber">
              <a-input v-model="model.examinationNumber" placeholder="请输入准考证号"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="考生号" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="examNumber">
              <a-input v-model="model.examNumber" placeholder="请输入考生号"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="是否跟读" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="ifFollow">
              <a-input-number v-model="model.ifFollow" placeholder="请输入是否跟读" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="计划性质" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="planType">
              <a-input-number v-model="model.planType" placeholder="请输入计划性质" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="学籍年" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="schoolYear">
              <a-input-number v-model="model.schoolYear" placeholder="请输入学籍年" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="院系" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="deptName">
              <a-input v-model="model.deptName" placeholder="请输入院系"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="录取专业" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="majorName">
              <a-input v-model="model.majorName" placeholder="请输入录取专业"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="总成绩" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="enterScore">
              <a-input v-model="model.enterScore" placeholder="请输入总成绩"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="考生类型" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="examineeType">
              <a-input-number v-model="model.examineeType" placeholder="请输入考生类型" style="width: 100%" />
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="考生类别" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="examineeCategory">
              <a-input-number v-model="model.examineeCategory" placeholder="请输入考生类别" style="width: 100%" />
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
    name: 'RecruitAdmissionStudentForm',
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
          add: "/manage/recruitAdmissionStudent/add",
          edit: "/manage/recruitAdmissionStudent/edit",
          queryById: "/manage/recruitAdmissionStudent/queryById"
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