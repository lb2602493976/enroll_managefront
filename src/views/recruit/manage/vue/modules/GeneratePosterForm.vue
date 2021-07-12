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
            <a-form-model-item label="类型（1：图片，2：文字，3版式）" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="type">
              <!-- <a-input v-model="model.type" placeholder="请输入类型（1：图片，2：文字，3版式）"  ></a-input> -->
              <a-select
                placeholder="请选择"
                @change="handleChange"
                :value="model.type"
              >
                <a-select-option
                  v-for="(item,index) of typeList" :key="index"
                  :value="item.value">
                    {{item.label}}
                </a-select-option>
              </a-select>
            </a-form-model-item>
          </a-col>
          <a-col :span="24" v-if="active==0">
            <a-form-model-item label="图片" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="content">
              <!-- <a-input v-model="model.content" placeholder="请输入内容"  ></a-input> -->
              <a-upload
                  style="width: 128px;height: 128px;"
                  name="file"
                  list-type="picture-card"
                  v-model="model.content"
                  class="avatar-uploader"
                  :show-upload-list="false"
                  :action="`${BASE_API}/upload/uploadPic`"
                  @change="handleChange2"
                  :before-upload="beforeUpload"
                >
                
                  <img style="width: 128px;height: 128px;" v-if="model.content" :src="model.content" alt="avatar" />
                  <div v-else>
                    <a-icon :type="loading ? 'loading' : 'plus'" />
                    <div class="ant-upload-text">
                      Upload
                    </div>
                  </div>
                </a-upload>
            </a-form-model-item>
          </a-col>
          <a-col :span="24" v-else-if="active==1">
            <a-form-model-item label="内容" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="content">
              <a-input v-model="model.content" placeholder="请输入内容"  ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24" v-else-if="active==2">
            <a-form-model-item label="板式" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="content">
              <!-- 上下左右 0123 -->
              <!-- <a-input v-model="model.content" placeholder="请输入内容"  ></a-input> -->
              <a-select
                placeholder="请选择"
                @change="handleChangeType"
              >
                <a-select-option
                  v-for="(item,index) of typeList1" :key="index"
                  :value="item.value">
                    {{item.label}}
                </a-select-option>
              </a-select>
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
    name: 'GeneratePosterForm',
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
        typeList:[
          // 1：，2：，3版式
          {label:'图片',value:0},
          {label:'文字',value:1},
          {label:'版式',value:2},
        ],
        typeList1:[
          // 1：，2：，3版式
          {label:'上',value:0},
          {label:'下',value:1},
          {label:'左',value:2},
          {label:'右',value:3},
        ],
        active:'10',
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
          //  content: [
          //     { required: true, message: '不能为空!'},
          //  ],
           type: [
              { required: true, message: '请选择类型!'},
           ],
          //  cmFile: [
          //     { required: true, message: '请输入附件!'},
          //  ],
        },
        url: {
          add: "/manage/generatePoster/add",
          edit: "/manage/generatePoster/edit",
          queryById: "/manage/generatePoster/queryById"
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
      handleChange(value) {
        this.active=value
        console.log(value,'value')
        this.model.type = value;
      },
      handleChangeType(val){
        this.model.content = val;
      },
      handleChange2(info) {
        if (info.file.status === 'uploading') {
          this.loading = true;
          return;
        }else if (info.file.status === 'done') {
           console.log(info.file,'info')
          this.model.content=info.file.response.url
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