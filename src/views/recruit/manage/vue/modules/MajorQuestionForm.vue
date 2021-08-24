<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="问题描述" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="title">
              <a-input v-model="model.title" placeholder="请输入问题描述"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="回复内容" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="content">
              <a-input v-model="model.content" placeholder="请输入回复内容"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="专业" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="majorId">
              <!-- <a-input v-model="model.majorId" placeholder="请输入专业id"  ></a-input> -->
              <a-select @change="handleSelectChange" v-model="model.majorId" placeholder="请选择专业">
                <a-select-option
                  v-for="(item,index) of newsList" 
                  :key="index"
                  :value="item.itemValue"
                  :label="item.itemText"
                >
                  {{item.itemText}}
                </a-select-option>
              </a-select>
            </a-form-model-item>
          </a-col>
          <!-- <a-col :span="24">
            <a-form-model-item label="租户id" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="tenantId">
              <a-input v-model="model.tenantId" placeholder="请输入租户id"  ></a-input>
            </a-form-model-item>
          </a-col>  -->
        </a-row>
      </a-form-model>
    </j-form-container>
  </a-spin>
</template>

<script>

  import { httpAction, getAction } from '@/api/manage'
  import { addMajorQuestion } from '@/api/api'
  import { validateDuplicateValue } from '@/utils/util'

  export default {
    name: 'MajorQuestionForm',
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
        newsList:[],  //新闻资讯
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
          majorId:[{required:true,message: '请选择专业'}],
          content:[{required:true,message: '请输入回复内容'}],
          title:[{required:true,message: '请输入问题描述'}],
        },
        url: {
          add: "/manage/majorQuestion/add",
          edit: "/manage/majorQuestion/edit",
          queryById: "/manage/majorQuestion/queryById"
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
      addMajorQuestion({pageSize:999,pageNo:1}).then(res=>{
        this.newsList=res.result.records.map(item=>{
          return {itemValue:item.id,itemText:item.miName}
        })
        console.log(this.newsList,'res')
      })
    },
    methods: {
      handleSelectChange(val){
        console.log(val,'专业值')
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