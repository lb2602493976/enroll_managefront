<!--宣传图片-->
<template>
    <div class="container">
        <div v-if="pageCtrl === 1" class="page page1" :class="{ empty:page1.empty }">
          <a-spin v-if="loading" class="spin" size="large"></a-spin>
          <template v-else>
            <div class="header1">
              <a-button type="primary" @click="addLv1Button">添加</a-button>
            </div>
            <ul class="list">
              <li class="item" v-for="item of list" :key="item.id" @click="handleLv1ItemClick(item)">
                <div class="top">
                  {{ item.type|type(imgTypes) }}
                </div>
                <div class="middle">
                  {{  item.tagName }}
                </div>
                <div style="font-size:12px;margin-top:24px">封面图片：</div>
                <div class="bottom" @click.stop="handleLv1SetCover(item)">
                  <template v-if="item.coverPicture && item.coverPicture.length">
                    <img v-for="(img,index) of item.coverPicture" :key="index" :src="img" alt="图片加载失败">
                  </template>
                  <template v-else>
                    <a-button type="link">设置封面</a-button>
                  </template>
                </div>
                <div class="buttons">
                  <a-button class="button" @click.stop="handleLv1Update(item)" >编辑</a-button>
                  <a-button class="button" @click.stop="handleLv1Delete(item)" type="danger">删除</a-button>
                </div>
              </li>
            </ul>
          </template>
          
        </div>
        <div v-if="pageCtrl === 2" class="page page2" :class="{ empty:page2.empty }">
          <a-spin v-if="loading" class="spin" size="large"></a-spin>
          <template v-else>
            <div class="header1">
              <span style="color:#722ED1;cursor:pointer;" @click="toPrev(1)">返回上一级</span>
            </div>
            <div class="header2">
              <a-button type="primary" @click="addLv2Button">添加</a-button>
            </div>
            <ul class="list">
              <li class="item" v-for="item of list" :key="item.id" @click="handleLv2ItemClick(item)">
                <div class="middle">
                  {{  item.tagName }}
                </div>
                <div style="font-size:12px;margin-top:24px">封面图片：</div>
                <div class="bottom" @click.stop="handleLv2SetCover(item)">
                  <template v-if="item.coverPicture && item.coverPicture.length">
                    <img v-for="(img,index) of item.coverPicture" :key="index" :src="img" alt="图片加载失败">
                  </template>
                  <template v-else>
                    <a-button type="link">设置封面</a-button>
                  </template>
                </div>
                <div class="buttons">
                  <a-button class="button" @click.stop="handleLv2Update(item)" >编辑</a-button>
                  <a-button class="button" @click.stop="handleLv2Delete(item)" type="danger">删除</a-button>
                </div>
              </li>
            </ul>
          </template>
          
        </div>
        <div v-if="pageCtrl === 3"  class="page page3" :class="{ empty:page3.empty }">
          <a-spin v-if="loading" class="spin" size="large"></a-spin>
          <template v-else>
            <div class="header1">
              <span style="color:#722ED1;cursor:pointer;" @click="toPrev(2)">返回上一级</span>
            </div>
            <div class="header2">
              <a-button type="primary" @click="addLv3Button">添加</a-button>
            </div>
            <ul class="list">
              <li class="item" v-for="item of list" :key="item.id">
                <img :src="item.picture">
                <div class="buttons">
                  <a-button class="button" @click.stop="handleLv3Delete(item)" type="danger">删除</a-button>
                </div>
              </li>
            </ul>
            
          </template>
      </div>
      <div class="pagination">
        <a-pagination :current="pageNo" :pageSize.sync="pageSize" :total="total" @change="onPageChange" @showSizeChange="onPageChange" show-quick-jumper show-size-changer/>
      </div>
      <a-modal
        :title="lv1FormTitle"
        :visible="lv1AddVisible"
        :confirm-loading="lv1AddConfirmLoading"
        @ok="handleLv1AddOk"
        @cancel="handleLv1AddCancel"
        width="300px"
        
      >
        <a-form-model ref="lv1AddForm" :model="lv1AddForm" layout="vertical" :rules="lv1AddRules">
          <a-form-model-item label="图片类型" prop="type">
            <a-select v-model="lv1AddForm.type" style="width: 100%" placeholder="请选择图片类型">
              <a-select-option v-for="item of imgTypes" :key="item.id" :value="item.itemValue">
                {{ item.itemText }}
              </a-select-option>
            </a-select>
          </a-form-model-item>
          <a-form-model-item label="标签名称" prop="tagName">
            <a-input v-model="lv1AddForm.tagName" placeholder="请输入标签名称"/>
          </a-form-model-item>
        </a-form-model>
    </a-modal>
    <a-modal
        title="设置一级封面"
        :visible="lv1CoverVisible"
        :confirm-loading="lv1CoverConfirmLoading"
        @ok="handleLv1CoverOk"
        @cancel="handleLv1CoverCancel"
        width="472px" 
      >
        <div class="lv1CoverBox">
          <div @click="handleLv1UploadImg(0)">
            <img v-if="lv1CoverImgList && lv1CoverImgList[0]" :src="lv1CoverImgList[0]">
            <a-icon v-else type="plus" style="font-size:40px;"/>
          </div>
          <div @click="handleLv1UploadImg(1)">
            <img v-if="lv1CoverImgList && lv1CoverImgList[1]" :src="lv1CoverImgList[1]">
            <a-icon v-else type="plus" style="font-size:40px;"/>
          </div>
          <div @click="handleLv1UploadImg(2)">
            <img v-if="lv1CoverImgList && lv1CoverImgList[2]" :src="lv1CoverImgList[2]">
            <a-icon v-else type="plus" style="font-size:40px;"/>
          </div>
          <div @click="handleLv1UploadImg(3)">
            <img v-if="lv1CoverImgList && lv1CoverImgList[3]" :src="lv1CoverImgList[3]">
            <a-icon v-else type="plus" style="font-size:40px;"/>
          </div>
        </div>
    </a-modal>
    <a-modal
        :title="lv2FormTitle"
        :visible="lv2AddVisible"
        :confirm-loading="lv2AddConfirmLoading"
        @ok="handleLv2AddOk"
        @cancel="handleLv2AddCancel"
        width="300px"
        
      >
        <a-form-model ref="lv2AddForm" :model="lv2AddForm" layout="vertical" :rules="lv2AddRules">
          <a-form-model-item label="标签名称" prop="tagName">
            <a-input v-model="lv2AddForm.tagName" placeholder="请输入标签名称"/>
          </a-form-model-item>
        </a-form-model>
    </a-modal>
    <a-modal
        title="设置二级封面"
        :visible="lv2CoverVisible"
        :confirm-loading="lv2CoverConfirmLoading"
        @ok="handleLv2CoverOk"
        @cancel="handleLv2CoverCancel"
        width="248px" 
      >
        <div class="lv2CoverBox">
          <div @click="handleLv2UploadImg(0)">
            <img v-if="lv2CoverImgList && lv2CoverImgList[0]" :src="lv2CoverImgList[0]">
            <a-icon v-else type="plus" style="font-size:40px;"/>
          </div>
        </div>
    </a-modal>
    <input v-show="false" ref="imgfile" type="file" accept=".jpg,.jpeg,.png,.bmp" @change="handleFileChange($event,uploadSuccess)">
    </div>
</template>

<script>
  import { getDictOne } from '@/api/api'
  import moment from 'moment'
  import { axios } from '@/utils/request'
  import { ACCESS_TOKEN } from "@/store/mutation-types"
  export default {
    filters:{
      type(val,imgTypes){
        if(imgTypes && imgTypes.length){
          let obj = imgTypes.find(item => item.itemValue === val)
          return obj ? obj.itemText : ''
        }
        return ''
      },
    },
    data () {
      return {
        uploadAction:window._CONFIG['domianURL']+"/upload/uploadPic",
        preview:window._CONFIG['domianURL']+"/sys/common/static/",
        headers:{
          'X-Access-Token' : this.$ls.get(ACCESS_TOKEN)
        },
        loading:false,
        lv1AddVisible:false,
        lv1AddConfirmLoading:false,
        lv1AddForm:{
          tagName:undefined,
          value:undefined,
          coverPicture:'',
        },
        lv1AddRules:{
          type:[
            { required:true,message:'类型不能为空' },
          ],
          tagName:[
            { required:true,message:'标签名称不能为空' },
          ],
        },
        lv1CoverVisible:false,
        lv1CoverConfirmLoading:false,
        lv1CoverImgList:[],
        currentLv1:null,
        lv2AddVisible:false,
        lv2AddConfirmLoading:false,
        lv2AddForm:{
          tagName:undefined,
          value:undefined,
          coverPicture:'',
        },
        lv2AddRules:{
          tagName:[
            { required:true,message:'标签名称不能为空' },
          ],
        },
        lv2CoverVisible:false,
        lv2CoverConfirmLoading:false,
        lv2CoverImgList:[],
        currentLv2:null,
        imgTypes:[],
        pageCtrl:1,
        pageNo:1,
        pageSize:10,
        total:0,
        title1:'',
        title2:'',
        page1:{
          empty:false,
        },
        page2:{
          empty:false,
        },
        page3:{
          empty:false,
        },
        list:[],
        uploadSuccess:()=>{},
      }
    },
    computed:{
      lv1FormTitle(){
        return this.lv1AddForm.id ? '修改一级分类' : '添加一级分类'
      },
      lv2FormTitle(){
        return this.lv2AddForm.id ? '修改二级分类' : '添加二级分类'
      },
    },
    mounted(){
      getDictOne({dictCode:'image_types'}).then(res=>{
        this.imgTypes = res.result
      })
      this.handleSearch()
    },
    methods: {
      toPrev(num){
        this.pageCtrl = num
        this.handleSearch()
      },
      handleFileChange(e,success){
        let file = e.target.files[0]
        console.log(file,'file')
        let valid = ['jpg','jpeg','bmp','png'].some(item => `image/${item}` === file.type)
        if(valid){
          let { headers } = this
          let formData = new FormData()
          formData.append('file',file)
          axios.post(`/upload/uploadPic`,formData,{ 'Content-type':'multipart/form-data' }).then(res => {
            if(res && res.url)
              success && success(res.url)
            else
              this.$message.error('上传文件失败')

              e.target.value = ''
          })
          
        }else{
          this.$message.error('仅支持 .jpg .jpeg .bmp .png 格式的图片文件')
        }
      },
      onPageChange(pageNo,pageSize) {
        this.pageNo = pageNo
        this.pageSize = pageSize
        this.handleSearch()
      },
      handleSearch(){
        this.loading = true
        let { headers,pageNo,pageSize } = this
        if(this.pageCtrl === 1){
          axios.get('/manage/coverPicture/list',{ headers,params:{ pageNo,pageSize } }).then(res => {
            this.list = res.result.records.map(item => ({ ...item,coverPicture:item.coverPicture ? item.coverPicture.split(',') :[] }))
            this.total = res.result.total
          }).finally(()=>{
            this.loading = false
          })
        }
        if(this.pageCtrl === 2){
          axios.get('/manage/coverPictureTwo/list',{ headers,params:{ pageNo,pageSize,coverId:this.currentLv1.id } }).then(res => {
            this.list = res.result.records.map(item => ({ ...item,coverPicture:item.coverPicture ? item.coverPicture.split(',') :[] }))
            this.total = res.result.total
          }).finally(()=>{
            this.loading = false
          })
        }
        if(this.pageCtrl === 3){
          axios.get('/manage/coverPictureThree/list',{ headers,params:{ pageNo,pageSize,twoId:this.currentLv2.id } }).then(res => {
            this.list = res.result.records
            this.total = res.result.total
          }).finally(()=>{
            this.loading = false
          })
        }
      },
      addLv1Button(){
        this.lv1AddVisible = true
      },
      handleLv1AddOk(){
        this.$refs['lv1AddForm'].validate(pass => {
          if(pass){
            let { headers } = this
            this.lv1AddConfirmLoading = true
            if(!this.lv1AddForm.id){
              axios.post('/manage/coverPicture/add',this.lv1AddForm,{ headers }).then(res => {
                if(res.result){
                  this.$message.success('添加成功')
                  this.lv1AddVisible = false
                  this.handleSearch()
                  this.lv1AddForm={
                    tagName:undefined,
                    value:undefined,
                    coverPicture:'',
                  }
                }
              }).finally(()=>{
                this.lv1AddConfirmLoading = false
              })
            }else{
              axios.put('/manage/coverPicture/edit',{ ...this.lv1AddForm,coverPicture:this.lv1AddForm.coverPicture.join(',') },{ headers }).then(res => {
                if(res.result){
                  this.$message.success('修改成功')
                  this.lv1AddVisible = false
                  this.handleSearch()
                  this.lv1AddForm={
                    tagName:undefined,
                    value:undefined,
                    coverPicture:'',
                  }
                }
              }).finally(()=>{
                this.lv1AddConfirmLoading = false
              })
            }
          }
        })
      },
      handleLv1AddCancel(){
        this.lv1AddForm = {
          tagName:undefined,
          value:undefined,
          coverPicture:'',
        }
        this.lv1AddVisible = false
      },
      handleLv1SetCover(item){
        this.currentLv1 = { ...item }
        this.lv1CoverImgList = [ ...item.coverPicture ]
        this.$nextTick(()=>{
          this.lv1CoverVisible = true
        })
      },
      handleLv1UploadImg(index){
        this.$refs['imgfile'].click()
        this.uploadSuccess = url => {
          console.log(url,'url')
          this.$set(this.lv1CoverImgList,index,url)
        }
      },
      handleLv1CoverOk(){
        this.lv1CoverConfirmLoading = true
        let data = { ...this.currentLv1,coverPicture:this.lv1CoverImgList.join(',') }
        let { headers } = this
        axios.put('/manage/coverPicture/edit',data,{ headers }).then(res => {
          if(res.result){
            this.$message.success('添加成功')
            this.lv1CoverVisible = false
            this.handleSearch()
          }
        }).finally(()=>{
          this.lv1CoverConfirmLoading = false
        })
      },
      handleLv1CoverCancel(){
        this.lv1CoverVisible = false
      },
      handleLv1Update(item){
        this.lv1AddForm = { ...item }
        this.lv1AddVisible = true
      },
      handleLv1Delete(item){
        this.$confirm({
          title: '删除',
          content: '删除该条数据会删除该数据下的所有子数据，是否删除？',
          onOk:()=> {
            let { headers } = this
            axios.delete('/manage/coverPicture/delete',{ headers,params:{ id:item.id } }).then(res => {
              if(res.result){
                this.$message.success('删除成功')
                this.handleSearch()
              }
            }).finally(()=>{
              this.lv1AddConfirmLoading = false
            })
          },
        });
      },
      handleLv1ItemClick(item){
        this.currentLv1 = { ...item }
        this.pageCtrl = 2
        this.pageNo = 1
        this.handleSearch()
      },
      //二级相关方法
      addLv2Button(){
        this.lv2AddVisible = true
      },
      handleLv2AddOk(){
        this.$refs['lv2AddForm'].validate(pass => {
          if(pass){
            let { headers } = this
            this.lv2AddConfirmLoading = true
            if(!this.lv2AddForm.id){
              axios.post('/manage/coverPictureTwo/add',{...this.lv2AddForm,coverId:this.currentLv1.id},{ headers }).then(res => {
                if(res.result){
                  this.$message.success('添加成功')
                  this.lv2AddVisible = false
                  this.handleSearch()
                  this.lv2AddForm={
                    tagName:undefined,
                    value:undefined,
                    coverPicture:'',
                  }
                }
              }).finally(()=>{
                this.lv2AddConfirmLoading = false
              })
            }else{
              axios.put('/manage/coverPictureTwo/edit',{ ...this.lv2AddForm,coverPicture:this.lv2AddForm.coverPicture.join(','),coverId:this.currentLv1.id },{ headers }).then(res => {
                if(res.result){
                  this.$message.success('修改成功')
                  this.lv2AddVisible = false
                  this.handleSearch()
                  this.lv2AddForm={
                    tagName:undefined,
                    value:undefined,
                    coverPicture:'',
                  }
                }
              }).finally(()=>{
                this.lv2AddConfirmLoading = false
              })
            }
          }
        })
      },
      handleLv2AddCancel(){
        this.lv2AddForm = {
          tagName:undefined,
          value:undefined,
          coverPicture:'',
        }
        this.lv2AddVisible = false
      },
      handleLv2SetCover(item){
        this.currentLv2 = { ...item }
        this.lv2CoverImgList = [ ...item.coverPicture ]
        this.$nextTick(()=>{
          this.lv2CoverVisible = true
        })
      },
      handleLv2UploadImg(index){
        this.$refs['imgfile'].click()
        this.uploadSuccess = url => {
          console.log(url,'url')
          this.$set(this.lv2CoverImgList,index,url)
        }
      },
      handleLv2CoverOk(){
        this.lv2CoverConfirmLoading = true
        let data = { ...this.currentLv2,coverPicture:this.lv2CoverImgList.join(',') }
        let { headers } = this
        axios.put('/manage/coverPictureTwo/edit',data,{ headers }).then(res => {
          if(res.result){
            this.$message.success('添加成功')
            this.lv2CoverVisible = false
            this.handleSearch()
          }
        }).finally(()=>{
          this.lv2CoverConfirmLoading = false
        })
      },
      handleLv2CoverCancel(){
        this.lv2CoverVisible = false
      },
      handleLv2Update(item){
        this.lv2AddForm = { ...item }
        this.lv2AddVisible = true
      },
      handleLv2Delete(item){
        this.$confirm({
          title: '删除',
          content: '删除该条数据会删除该数据下的所有子数据，是否删除？',
          onOk:()=> {
            let { headers } = this
            axios.delete('/manage/coverPictureTwo/delete',{ headers,params:{ id:item.id } }).then(res => {
              if(res.result){
                this.$message.success('删除成功')
                this.handleSearch()
              }
            }).finally(()=>{
              this.lv2AddConfirmLoading = false
            })
          },
        });
      },
      handleLv2ItemClick(item){
        this.currentLv2 = { ...item }
        this.pageCtrl = 3
        this.pageNo = 1
        this.handleSearch()
      },
      //三级相关方法
      addLv3Button(){
        this.$refs['imgfile'].click()
        this.uploadSuccess = url => {
          let { headers } = this
          this.loading = true
          axios.post('/manage/coverPictureThree/add',{picture:url,twoId:this.currentLv2.id},{ headers }).then(res => {
            if(res.result){
              this.$message.success('添加成功')
              this.handleSearch()
            }
          }).finally(()=>{
            this.loading = false
          })
        }
      },
      handleLv3Delete(item){
        this.$confirm({
          title: '删除',
          content: '确认删除该图片吗？',
          onOk:()=> {
            let { headers } = this
            axios.delete('/manage/coverPictureThree/delete',{ headers,params:{ id:item.id } }).then(res => {
              if(res.result){
                this.$message.success('删除成功')
                this.handleSearch()
              }
            })
          },
        });
      },
    },
  }
</script>

<style lang="less" scoped>
.spin{
  position:absolute;
  top:50%;
  left:50%;
  transform:translate(-50%,-50%);
}
.lv1CoverBox{
  display:flex;
  flex-flow:row wrap;
  justify-content: flex-start;
  align-items: center;
  gap:24px;
  &>div{
    border:2px dashed #DDD;
    width:200px;
    height:200px;
    display:flex;
    flex-flow:row nowrap;
    justify-content: center;
    align-items: center;
    cursor:pointer;
    img{
      width:100%;
      height:100%;
    }
  }
}
.lv2CoverBox{
  display:flex;
  flex-flow:row wrap;
  justify-content: center;
  align-items: center;
  gap:24px;
  &>div{
    border:2px dashed #DDD;
    width:200px;
    height:200px;
    display:flex;
    flex-flow:row nowrap;
    justify-content: center;
    align-items: center;
    cursor:pointer;
    img{
      width:100%;
      height:100%;
    }
  }
}
.container{
  width:100%;
  height:100%;
  ul,li{
    list-style: none;
  }
  background:#FFF;
  .page{
    width:100%;
    min-height:600px;
    position:relative;
  }
  .pagination{
    width:100%;
    display:flex;
    flex-flow:row nowrap;
    justify-content:flex-end;
    align-items:center;
    padding:12px;
  }
  .page1{
      .header1{
        width:100%;
        display:flex;
        flex-flow:row nowrap;
        justify-content:flex-end;
        align-items:center;
        box-sizing:border-box;
        padding:12px;
      }
      .list{
        display:flex;
        flex-flow:row wrap;
        justify-content:flex-start;
        align-items:center;
        padding:0 24px;
        gap:12px;
        .item{
          border-radius:14px;
          width:224px;
          box-shadow: 0px 0px 9px 0px rgba(0, 0, 0, 0.2);
          padding:12px;
          .top{
            overflow: hidden;
            text-overflow:ellipsis;
            white-space: nowrap;
            width:100%;
            text-align:left;
            font-size:12px;
            color:#722ED1;
          }
          .middle{
            overflow: hidden;
            text-overflow:ellipsis;
            white-space: nowrap;
            width:100%;
            text-align:left;
            font-size:16px;
            font-weight:bold;
          }
          .bottom{
            margin-top:6px;
            display:flex;
            flex-flow:row nowrap;
            justify-content:flex-end;
            align-items:center;
            cursor:pointer;
            font-size:12px;
            min-height:50px;
            img{
              width:50px;
              height:50px;
            }
          }
        }
      }
      .buttons{
        margin-top:12px;
        display:flex;
        flex-flow:row nowrap;
        justify-content: space-between;
        align-items: center;
        .button{
          width:calc(50% - 6px);
          &:not(:first-child){
            margin-left:12px;
          }
        }
      }
    }
    .page2{
      .header1{
        width:100%;
        padding:12px;
        box-sizing:border-box;
      }
      .header2{
        width:100%;
        display:flex;
        flex-flow:row nowrap;
        justify-content:flex-end;
        align-items:center;
        box-sizing:border-box;
        padding:12px;
      }
      .list{
        display:flex;
        flex-flow:row wrap;
        justify-content:flex-start;
        align-items:center;
        padding:0 24px;
        gap:12px;
        .item{
          border-radius:14px;
          width:224px;
          box-shadow: 0px 0px 9px 0px rgba(0, 0, 0, 0.2);
          padding:12px;
          .top{
            overflow: hidden;
            text-overflow:ellipsis;
            white-space: nowrap;
            width:100%;
            text-align:left;
            font-size:12px;
            color:#722ED1;
          }
          .middle{
            overflow: hidden;
            text-overflow:ellipsis;
            white-space: nowrap;
            width:100%;
            text-align:left;
            font-size:16px;
            font-weight:bold;
          }
          .bottom{
            margin-top:6px;
            display:flex;
            flex-flow:row nowrap;
            justify-content:flex-end;
            align-items:center;
            cursor:pointer;
            font-size:12px;
            min-height:50px;
            img{
              width:50px;
              height:50px;
            }
          }
        }
      }
      .buttons{
        margin-top:12px;
        display:flex;
        flex-flow:row nowrap;
        justify-content: space-between;
        align-items: center;
        .button{
          width:calc(50% - 6px);
          &:not(:first-child){
            margin-left:12px;
          }
        }
      }
    }
    .page3{
      .header1{
        width:100%;
        padding:12px;
        box-sizing:border-box;
      }
      .header2{
        width:100%;
        display:flex;
        flex-flow:row nowrap;
        justify-content:flex-end;
        align-items:center;
        box-sizing:border-box;
        padding:12px;
      }
      .list{
        display:flex;
        flex-flow:row wrap;
        justify-content:flex-start;
        align-items:center;
        padding:0 24px;
        gap:12px;
        .item{
          border-radius:14px;
          box-shadow: 0px 0px 9px 0px rgba(0, 0, 0, 0.2);
          padding:12px;
          img{
            width:200px;
            height:200px;
          }
          .buttons{
            width:100%;
            .button{
              width:100%;
              height:40px;
              line-height:40px;
              border-radius:0;
            }
          }
        }
      }
    }
}
  
</style>
