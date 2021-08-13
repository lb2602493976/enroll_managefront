<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <!-- <a-col :span="24">
            <a-form-model-item label="租户id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="tenantId">
              <a-input v-model="model.tenantId" placeholder="请输入租户id"  ></a-input>
            </a-form-model-item>
          </a-col> -->
          <a-col :span="24">
            <a-form-model-item label="团队名称" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="teamName">
              <a-input v-model="model.teamName" placeholder="请输入团队名称"  ></a-input>
            </a-form-model-item>
          </a-col>
          <!-- <a-col :span="24">
            <a-form-model-item label="团队负责人" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="headId">
              <a-input v-model="model.headId" placeholder="请输入团队负责人" style="width: 100%" ></a-input>
            </a-form-model-item> 
          </a-col> -->
          <a-col :span="24">
            <a-form-model-item label="负责区域" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="territory">
              <a-cascader :options="options" placeholder="请选择负责区域" v-model="xiaobaga" @change="onChange" change-on-select></a-cascader>
              <!-- <a-input v-model="model.territory" placeholder="请输入负责区域"  ></a-input> -->
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
  import  cityData  from '@/mixins/AdressMixin'
  export default {
    name: 'AdmissionsTeamForm',
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
        xiaobaga:[],
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
        options:cityData,
        url: {
          add: "/manage/admissionsTeam/add",
          edit: "/manage/admissionsTeam/edit",
          queryById: "/manage/admissionsTeam/queryById"
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
      onChange(value) {
        this.model.territory=value.join('/')
        console.log(this.model.territory,'value')
      },
      add () {
        this.edit(this.modelDefault);
      },
      edit (record) {
        this.model = Object.assign({}, record);
        this.xiaobaga=record.territory.split('/')
        console.log(this.model.territory,'record')
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