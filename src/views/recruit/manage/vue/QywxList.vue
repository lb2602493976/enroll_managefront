<template>
 <div>
   <a href="javascript:;" @click="ppp">
     <img src="https://open.work.weixin.qq.com/service/img?id=ww52be79b44772f40a&t=login&c=blue&s=large" srcset="https://open.work.weixin.qq.com/service/img?id=ww52be79b44772f40a&t=login&c=blue&s=large@2x 2x" referrerpolicy="unsafe-url" alt="企业微信登录">
   </a>

   <a href="javascript:;" @click="getDepart">
       获取部门列表
      </a>
 </div>
</template>

<script>
  import { axios } from '@/utils/request'
  export default {
    components: {},
    data () {
      return {
      }
    },
    created() {
    },
    computed: {},
    methods: {
      async ppp(){
        const res = await axios.get('/manage/qywxCorp/getAuthPage')
        console.log(res,88888)
        window.location.href = res.result
      },
      async getDepart(){
              const res = await axios.get('/manage/qywxCorp/getDepart')
            }

    }

  }
</script>
<style scoped>
</style>