<template>
  <a-spin :spinning="confirmLoading">
    <j-form-container :disabled="formDisabled">
      <a-form-model ref="form" :model="model" :rules="validatorRules" slot="detail">
        <a-row>
          <a-col :span="24">
            <a-form-model-item label="图片" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="picUrl">
              <j-image-upload isMultiple v-model="model.picUrl"></j-image-upload>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="标题" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="picTitle">
              <a-input v-model="model.picTitle" placeholder="请输入标题（不超过20个字）" :maxLength="20"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24">
            <a-form-model-item label="跳转类型" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="targetType">
              <j-dict-select-tag
                type="list"
                v-model="model.targetType"
                dictCode="target_type"
                placeholder="请选择跳转类型"
                @input="typeChange"
                @change="aaa"
              />
            </a-form-model-item>
          </a-col>
          <a-col :span="24" v-if="showInputPage">
            <a-form-model-item label="跳转链接" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="picHref">
              <a-input v-model="model.picHref" placeholder="请输入跳转链接"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24" v-if="showInputAppid">
            <a-form-model-item label="小程序appid" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="appid">
              <a-input v-model="model.appid" placeholder="请输入小程序appid"></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :span="24" v-if="showInputModule">
            <a-form-model-item label="宣传模块" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="moduleId">
              <a-select placeholder="请选择"  v-model="model.moduleId"  @change="moduleChange">
                <a-select-option v-for="(item, key) in dictOptions" :key="key" :value="item.value">
                  <span style="display: inline-block;width: 100%" :title="item.label ">
                    {{ item.label }}
                  </span>
                </a-select-option>
              </a-select>

<!--              <j-dict-select-tag-->
<!--                type="list"-->
<!--                v-model="model.moduleId"-->
<!--                dictCode="recruit_module,module_name,id"-->
<!--                placeholder="请选择宣传模块"-->
<!--                @input="moduleChange"-->
<!--              />-->
            </a-form-model-item>
          </a-col>
          <a-col :span="24" v-if="showInputModule && showInputModuleModuleId">
            <a-form-model-item label="二级模块" :labelCol="labelCol" :wrapperCol="wrapperCol" prop="detailId">
              <j-dict-select-tag
                type="list"
                v-model="model.detailId"
                placeholder="请选择二级模块"
                ref="changeOptions"
                :disabled='detailIdDisabled'
              />
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
  import { axios } from '@/utils/request'

  export default {
    name: 'RecruitBannerForm',
    components: {},
    props: {
      //表单禁用
      disabled: {
        type: Boolean,
        default: false,
        required: false,
      },
    },
    data() {
      return {
        detailIdDisabled:false,
        model: {},
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
          picUrl: [{ required: true, message: '请上传图片!' }],
          picTitle: [{ required: true, message: '请输入标题!' }],
          picHref: [
            { required: false, message: '请输入网址!' },
            {
              pattern: /^((ht|f)tps?):\/\/[\w\-]+(\.[\w\-]+)+([\w\-.,@?^=%&:\/~+#]*[\w\-@?^=%&\/~+#])?$/,
              message: '请输入正确的网址!',
            },
          ],
          appid: [{ required: false, message: '请输入小程序的appid!' }],
          moduleId: [{ required: false, message: '请选择宣传模块!' }],
          detailId: [{ required: false, message: '请选择二级模块!' }],
        },
        url: {
          add: '/manage/recruitBanner/add',
          edit: '/manage/recruitBanner/edit',
          queryById: '/manage/recruitBanner/queryById',
        },
        showInputPage: false,
        showInputAppid: false,
        showInputModule: false,
        showInputModuleModuleId: true,
        options: [],
        dictOptions: [],
      }
    },
    computed: {
      formDisabled() {
        return this.disabled
      },
    },
    created() {
      //备份model原始值
      this.modelDefault = JSON.parse(JSON.stringify(this.model))
      this.getSelect()
    },
    methods: {
      add() {
        this.edit(this.modelDefault)
      },
      edit(record) {
        console.log(record)
        if (record.targetType == 1) {
          this.showInputPage = true
          this.validatorRules.picHref[0].required = true
        } else if (record.targetType == 2) {
          this.showInputAppid = true
          this.validatorRules.appid[0].required = true
        } else {
          this.showInputModule = true
          this.validatorRules.moduleId[0].required = true
          this.validatorRules.detailId[0].required = true
        }
        this.model = Object.assign({}, record)
        this.visible = true
      },
      submitForm() {
        const that = this
        // 触发表单验证
        this.$refs.form.validate((valid) => {
          if (valid) {
            that.confirmLoading = true
            let httpurl = ''
            let method = ''
            if (!this.model.id) {
              httpurl += this.url.add
              method = 'post'
            } else {
              httpurl += this.url.edit
              method = 'put'
            }
            httpAction(httpurl, this.model, method)
              .then((res) => {
                if (res.success) {
                  that.$message.success(res.message)
                  that.$emit('ok')
                } else {
                  that.$message.warning(res.message)
                }
              })
              .finally(() => {
                that.confirmLoading = false
              })
          }
        })
      },
      typeChange() {
        if (this.model.targetType) {

          if (this.model.targetType == 1) {
            this.showInputPage = true
            this.validatorRules.picHref[0].required = true

            this.showInputAppid = false
            this.validatorRules.appid[0].required = false
            this.showInputModule = false
            this.validatorRules.moduleId[0].required = false
            this.validatorRules.detailId[0].required = false
          } else if (this.model.targetType == 2) {
            this.showInputAppid = true
            this.validatorRules.appid[0].required = true

            this.showInputPage = false
            this.validatorRules.picHref[0].required = false
            this.showInputModule = false
            this.validatorRules.moduleId[0].required = false
            this.validatorRules.detailId[0].required = false
          } else if(this.model.targetType == 0) {
            this.showInputPage = false
            this.validatorRules.picHref[0].required = false
            this.showInputAppid = false
            this.validatorRules.appid[0].required = false
            this.showInputModule = false
            this.validatorRules.moduleId[0].required = false
            this.validatorRules.detailId[0].required = false
          } else {
            this.showInputModule = true
            this.validatorRules.moduleId[0].required = true
            this.validatorRules.detailId[0].required = true

            this.showInputPage = false
            this.validatorRules.picHref[0].required = false
            this.showInputAppid = false
            this.validatorRules.appid[0].required = false
          }
        } else {
          this.showInputPage = false
          this.validatorRules.picHref[0].required = false
          this.showInputAppid = false
          this.validatorRules.appid[0].required = false
          this.showInputModule = false
          this.validatorRules.moduleId[0].required = false
          this.validatorRules.detailId[0].required = false
        }
      },
      moduleChange(value) {
        let a = this.dictOptions.filter(item => item.value === this.model.moduleId)

        this.showInputModuleModuleId = a[0].show === 'true' ? true :false
        if(this.showInputModuleModuleId) {


          //let module = this.model.moduleId
          if (this.model.moduleId) {
            let dictCode
            axios
              .get('/manage/recruitModule/queryById?id=' + this.model.moduleId)
              .then((res) => {
                console.log(res)
                if (res.success) {
                  let moduleId = res.result.sysPerId
                  console.log(moduleId)
                  switch (moduleId) {
                    case '1':
                      dictCode = 'recruit_school_ino,si_title,id'
                      break
                    case '2':
                      dictCode = 'recruit_college_info,ci_name,id'
                      break
                    case '3':
                      dictCode = 'recruit_major_info,mi_name,id'
                      break
                    case '4':
                      dictCode = 'recruit_teacher_info,ti_name,id'
                      break
                    default:
                      dictCode = 'recruit_module,module_name,id'
                      break
                  }
                  axios.get('/sys/dict/getDictItems/' + dictCode).then((res) => {
                    console.log(res)
                    this.options = res.result
                    //console.log(this.options)
                    this.$refs.changeOptions.setCurrentDictOptions(this.options)
                  })
                  if (moduleId != '4' && moduleId != '3' && moduleId != '2' && moduleId != '1') {
                    //console.log('**************')
                    this.model.detailId = this.model.moduleId
                    this.detailIdDisabled = true
                  } else {
                    this.model.detailId = undefined
                    this.detailIdDisabled = false
                  }
                }
              })
              .catch((err) => {
                console.log(err)
              })
              .finally(() => {
              })
          }
        }
        //this.model.moduleId = module
      },
      aaa(){
        if(this.model.targetType === '0'){
          this.showInputModule = false
          this.showInputPage = false
          this.showInputModuleModuleId = false
        }else if(this.model.targetType === '2'){
          this.showInputPage = true
          this.showInputModule = false
          this.showInputModuleModuleId = false
        }else if(this.model.targetType === '3'){
          this.showInputPage = false
          this.showInputModule = true
          this.showInputModuleModuleId = true
        }
      },
      getSelect(){
        axios
          .get('/manage/recruitModule/getModuleAndStatus')
          .then((res) => {
            console.log(res,7654)
            let a = []
            if (res.success) {
              res.result.map((item)=>{
                a.push({
                  value:item.id,
                  label:item.module_name,
                  show:item.type
                })
              })
              this.dictOptions =a
            }
          })
          .catch((err) => {
            console.log(err)
          })
          .finally(() => {})
      }
    },
  }
</script>