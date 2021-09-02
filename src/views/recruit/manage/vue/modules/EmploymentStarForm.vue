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
            <a-form-model-item label="介绍" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="content">
              <a-input v-model="model.content" placeholder="请输入介绍"  ></a-input>
            </a-form-model-item>
          </a-col> 
          <a-col :span="24">
            <a-form-model-item label="封面照片" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="coverPhoto">
              <!-- <a-input v-model="model.coverPhoto" placeholder="请输入封面照片"  ></a-input> -->
              <a-upload
                style="width: 128px;height: 128px;"
                name="file"
                list-type="picture-card"
                v-model="model.coverPhoto"
                class="avatar-uploader"
                :show-upload-list="false"
                :action="`${BASE_API}/upload/uploadPic`"
                @change="handleChange"
                :before-upload="beforeUpload"
              >
              
                <img style="width: 128px;height: 128px;" v-if="model.coverPhoto" :src="model.coverPhoto" alt="avatar" />
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
            <a-form-model-item label="排序" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="sort">
              <a-input-number v-model="model.sort" placeholder="请输入排序" style="width: 100%" />
            </a-form-model-item>
          </a-col>

          <a-col :span="24">
            <a-form-model-item label="所属专业" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="majorId">
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
          </a-col> -->
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
    name: 'EmploymentStarForm',
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
        newsList:[],  //就业明星
        BASE_API:window._CONFIG['domianURL'],
        loading : false,
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
          coverPhoto:[{required:true,message:'封面图片不能为空！'}],
          name:[{required:true,message:'姓名不能为空！'}],
          content:[{required:true,message:'介绍不能为空！'}],
          sort:[{required:true,message:'排序不能为空！'}],
        },
        url: {
          add: "/manage/employmentStar/add",
          edit: "/manage/employmentStar/edit",
          queryById: "/manage/employmentStar/queryById"
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
      // 上传
      handleChange(info) {
        if (info.file.status === 'uploading') {
          this.loading = true;
          return;
        }
        if (info.file.status === 'done') {
           console.log(info.file,'info')
          this.model.coverPhoto=info.file.response.url
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