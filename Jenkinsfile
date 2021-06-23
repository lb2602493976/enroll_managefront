import groovy.json.JsonSlurper

node {
    properties([parameters([string(defaultValue: '0.0.1', description: '请输入要发布的版本', name: 'VERSION')])])
    if (params.VERSION == '') {
        error '参数输入错误'
    }

    currentBuild.result = "SUCCESS"
    echo "PWD: ${pwd()}"

    // 默认设置
    env.VERSION = params.VERSION
    def registryName = 'test'
    def imageName = 'test'
    def type = 'back'
    def input_result // 用户输入项

    try {

        stage('config') {
            input_result = input message: '选择执行任务', ok: 'ok', parameters: [
                booleanParam(name: 'build', defaultValue: true),
                booleanParam(name: 'test', defaultValue: true),
                booleanParam(name: 'deploy', defaultValue: false)
            ]
        }

        def mvnHome = tool 'maven3.5.3'
        env.PATH = "${mvnHome}/bin:${env.PATH}"

        stage('checkout') {
            try {
                sh 'git checkout .'
            } catch (err) {

            }

            checkout scm
            sh 'ls'
        }

        // 读取配置信息
        if (fileExists('./config.json')) {

            echo("json file is exists")

            def str = readFile 'config.json'
            def jsonSlurper = new JsonSlurper()
            def obj = jsonSlurper.parseText(str)

            registryName = obj.registryName
            type = obj.type

            para = obj.para
            containerName = obj.containerName
            echo("json file is read finished")
        }

        imageName = "${registryName}:${env.VERSION}"
        echo("VERSION: ${imageName}")
        echo("TYPE: ${type}")

        stage('build') {
            if (input_result.build && type == "front") {
                sh "docker build -t ${registryName} ."
                echo "Image build complete"
            }
            if (input_result.build && type == "back") {
                sh "mvn -DskipTests=true -DimageName=${registryName} clean package docker:build"
                echo "Image build complete"

            }
        }


        stage('test') {
            if (input_result.test) {
                try {
                    sh "docker rm -f ${containerName}"
                } catch (err) {

                }
                sh "docker run -itd ${para} --name ${containerName} ${registryName}"
                echo "Application started"
            }
        }


        stage('deploy') {
            if (input_result.deploy) {
                withCredentials([usernamePassword(credentialsId: 'docker-registry', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh "docker tag ${registryName} ${imageName}"
                    sh "docker login --username=${USERNAME} -p '${PASSWORD}' registry.cn-hangzhou.aliyuncs.com"
                    sh "docker push ${registryName}"
                    sh "docker push ${imageName}"
                    echo "Image push complete"
                }
            }
        }

    } catch (err) {
        currentBuild.result = "FAILURE"
        throw err
    }

}
