<template>
  <div><!--  测试  -->
    <div v-for="item of imgList" :key="item.id">
      <img :src="item.url" alt="" width="100%" height="500px">
    </div>
  </div><!--   测试 -->
</template>

<script>
 
  export default {
    components: {
      
    },
    data () {
      return {
        imgList:[
          {id:1,url:'https://file.yunquewang.cn/group1/default/20211013/11/48/4/background1.jpg'},
          {id:2,url:'https://file.yunquewang.cn/group1/image/1634631099(1).jpg'},
          {id:3,url:'https://file.yunquewang.cn/group1/default/20211020/10/08/4/607e4885c8283b6def6160776a90117.png'},
          {id:4,url:'https://file.yunquewang.cn/group1/default/20211020/10/08/4/9e9e29bcf3e2d5c85a9390baa8fea64.png'},
          {id:5,url:'https://file.yunquewang.cn/group1/default/20211020/10/09/4/adc35a077ad51dda3e512dca29138f5.png'},
          {id:6,url:'https://file.yunquewang.cn/group1/default/20211020/10/09/4/bd719dba6b5f3a7d903969b123c2db7.png'},
          {id:7,url:'https://file.yunquewang.cn/group1/default/20211020/10/09/4/bd5147160b449373bebb82316ffa827.png'},
          {id:8,url:'https://file.yunquewang.cn/group1/default/20211020/10/10/4/fa2d9361b560feafd48f2b2660532d8.png'},
          ],
        
      }
    },
    created () {
      
    },
    methods: {
      
    }
  }
</script>

<style lang="less" scoped>

  
</style>
<style>
  
</style>